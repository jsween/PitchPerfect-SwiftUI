//
//  SoundEffect.swift
//  PitchPerfect
//
//  Created by Jonathan Sweeney on 8/20/22.
//

import Foundation

struct SoundEffect {
    let name: String
    let rate: Float?
    let pitch: Float?
    let echo: Bool?
    let reverb: Bool?
    
    static let soundEffects: [SoundEffect] = [
        SoundEffect(name: "Slow", rate: 0.5, pitch: nil, echo: nil, reverb: nil),
        SoundEffect(name: "Fast", rate: 1.5, pitch: nil, echo: nil, reverb: nil),
        SoundEffect(name: "HighPitch", rate: nil, pitch: 1_000, echo: nil, reverb: nil),
        SoundEffect(name: "LowPitch", rate: nil, pitch: -1_000, echo: nil, reverb: nil),
        SoundEffect(name: "Echo", rate: nil, pitch: nil, echo: true, reverb: nil),
        SoundEffect(name: "Reverb", rate: nil, pitch: nil, echo: nil, reverb: true)
    ]
}
