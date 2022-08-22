//
//  Button+Extensions.swift
//  PitchPerfect
//
//  Created by Jonathan Sweeney on 8/21/22.
//

import Foundation
import SwiftUI

struct AudioButton: ButtonStyle {
    
    var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(isEnabled ? 1 : 0.5)
            .disabled(!isEnabled)
    }
}
