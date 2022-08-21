//
//  AudioViewModel.swift
//  PitchPerfect
//
//  Created by Jonathan Sweeney on 8/19/22.
//

import AVFoundation
import Combine
import SwiftUI

class AudioViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    // MARK: - Properties
    
    let objectWillChange = PassthroughSubject<AudioViewModel, Never>()
    
    var audioRecorder: AVAudioRecorder!
    var engine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    var audioFile: AVAudioFile!
    
    var recordingState: RecordingState = .notRecording {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var playingState: PlayingState = .notPlaying {
        didSet {
            objectWillChange.send(self)
        }
    }
        
    var showAlert: Bool = false
    var errorMessage: String = ""
}

// MARK: - Play Audio

extension AudioViewModel {
    
    var recordedAudioURL: URL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let pathArray = [dirPath, "audioFile.m4a"]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        return filePath!
    }
    
    func startPlayback(effect: SoundEffect) {
        
        // Stop any audio that may be playing
        if playingState == .playing {
            stopPlayback()
        }
        
        playingState = .playing
        
        audioFile = try! AVAudioFile(forReading: recordedAudioURL)
        
        // Initialize audio engine components
        engine = AVAudioEngine()
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        engine.attach(audioPlayerNode)
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = effect.pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = effect.rate {
            changeRatePitchNode.rate = rate
        }
        engine.attach(changeRatePitchNode)
        
        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        engine.attach(echoNode)
        
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        engine.attach(reverbNode)
        
        // connect nodes
        if effect.echo == true && effect.reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, engine.outputNode)
        } else if effect.echo == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, engine.outputNode)
        } else if effect.reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, engine.outputNode)
        } else {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, engine.outputNode)
        }
        
        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = effect.rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(AudioViewModel.stopPlayback), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoop.Mode.default)
        }
        
        do {
            try engine.start()
        } catch {
//            showAlert(Alerts.AudioEngineError, message: String(describing: error))
            print(K.Alerts.AudioEngineError)
            return
        }
        
        // play the recording!
        audioPlayerNode.play()
    }
    
    @objc func stopPlayback() {
        playingState = .notPlaying
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        if let engine = engine {
            engine.stop()
            engine.reset()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            playingState = .notPlaying
        }
    }
    
    // MARK: Connect List of Audio Nodes
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            engine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
}

// MARK: - Record Audio

extension AudioViewModel {
    
    // MARK: - Methods
    
    /***
     Start Recording Audio
     */
    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("audioFile.m4a")
        recordingState = .recording
        
        
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try session.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            
            recordingState = .recording
        } catch {
            print("Could not start recording")
        }
    }
    
    /***
     Stop Recording Audio
     */
    func stopRecording() {
        if let audioRecorder = audioRecorder {
            audioRecorder.stop()
        }
        recordingState = .notRecording
    }
    
}
