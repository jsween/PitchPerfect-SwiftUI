//
//  PlayBackScreen.swift
//  PitchPerfect
//
//  Created by Jonathan Sweeney on 8/19/22.
//

import SwiftUI
import AVFAudio

struct PlayBackScreen: View {

    @ObservedObject var audioPlayer: AudioViewModel
    
    var body: some View {
        VStack {
            ButtonRowView(audioPlayer: audioPlayer, leftEffect: SoundEffect.soundEffects[0], rightEffect: SoundEffect.soundEffects[1])
            ButtonRowView(audioPlayer: audioPlayer, leftEffect: SoundEffect.soundEffects[2], rightEffect: SoundEffect.soundEffects[3])
            ButtonRowView(audioPlayer: audioPlayer, leftEffect: SoundEffect.soundEffects[4], rightEffect: SoundEffect.soundEffects[5])
            Button {
                audioPlayer.stopPlayback()
            } label: {
                Image("Stop")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .padding(.top)
            }
            .buttonStyle(AudioButton(isEnabled: audioPlayer.playingState == .playing))
            .onDisappear {
                audioPlayer.stopPlayback()
            }
        }//: VStack
        .padding()
        
    }
}

struct PlayBackScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlayBackScreen(audioPlayer: AudioViewModel())
            .previewInterfaceOrientation(.portrait)
    }
}
