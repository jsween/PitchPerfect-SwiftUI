//
//  ContentView.swift
//  PitchPerfect
//
//  Created by Jonathan Sweeney on 8/19/22.
//

import SwiftUI

struct MainScreen: View {
    
    @ObservedObject var audioRecorder: AudioViewModel
    @State var showPlayBackScreen = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $showPlayBackScreen) {
                    PlayBackScreen(audioPlayer: audioRecorder)
                } label: { }
                Button {
                    audioRecorder.startRecording()
                } label: {
                    Image("Record")
                        .opacity(audioRecorder.recordingState == .notRecording ? 1.0 : 0.5)
                }.disabled(audioRecorder.recordingState == .recording)
                Text(audioRecorder.recordingState == .recording ? "Tap to Record" : "Recording")
                    .padding()
                Button {
                    audioRecorder.stopRecording()
                    showPlayBackScreen.toggle()
                } label: {
                    Image("Stop")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .opacity(audioRecorder.recordingState == .recording ? 1.0 : 0.5)
                }.disabled(audioRecorder.recordingState == .notRecording)
            }
        }//: VStack
        .onAppear {
            audioRecorder.recordingState = .notRecording
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(audioRecorder: AudioViewModel())
    }
}
