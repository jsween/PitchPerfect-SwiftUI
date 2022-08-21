//
//  ButtonRowView.swift
//  PitchPerfect
//
//  Created by Jonathan Sweeney on 8/21/22.
//

import SwiftUI

struct ButtonRowView: View {
    
    @ObservedObject var audioPlayer: AudioViewModel
    var leftEffect: SoundEffect
    var rightEffect: SoundEffect
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                audioPlayer.startPlayback(effect: leftEffect)
            } label: {
                Image(leftEffect.name)
            }
            .disabled(audioPlayer.playingState == .playing)
            .opacity(audioPlayer.playingState == .playing ? 0.5 : 1)
            Spacer()
            Spacer()
            Button {
                audioPlayer.startPlayback(effect: rightEffect)
            } label: {
                Image(rightEffect.name)
            }
            .disabled(audioPlayer.playingState == .playing)
            .opacity(audioPlayer.playingState == .playing ? 0.5 : 1)
            Spacer()
        }
    }
}

struct ButtonRowView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonRowView(audioPlayer: AudioViewModel(), leftEffect: SoundEffect.soundEffects[0], rightEffect: SoundEffect.soundEffects[1])
            .previewLayout(.sizeThatFits)
    }
}
