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
    
    private var isPlaying: Bool {
        return audioPlayer.playingState == .playing
    }
    
    var body: some View {
        HStack {
            Spacer()
            SoundEffectButton(audioPlayer: audioPlayer, soundEffect: leftEffect)
            Spacer()
            Spacer()
            SoundEffectButton(audioPlayer: audioPlayer, soundEffect: rightEffect)
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
