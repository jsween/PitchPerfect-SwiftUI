//
//  SoundEffectButton.swift
//  PitchPerfect
//
//  Created by Jonathan Sweeney on 8/21/22.
//

import SwiftUI

struct SoundEffectButton: View {
    
    @ObservedObject var audioPlayer: AudioViewModel
    var soundEffect: SoundEffect
    
    var body: some View {
        Button {
            audioPlayer.startPlayback(effect: soundEffect)
        } label: {
            Image(soundEffect.name)
        }
        .buttonStyle(AudioButton(isEnabled: audioPlayer.playingState == .notPlaying))
    }
}

struct SoundEffectButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SoundEffectButton(audioPlayer: AudioViewModel(), soundEffect: SoundEffect.slow)
            .previewLayout(.sizeThatFits)
    }
}
