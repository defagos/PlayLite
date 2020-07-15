//
//  PlayerView.swift
//  PlayLite
//
//  Created by Samuel Défago on 15.07.20.
//

import SRGLetterbox
import SwiftUI

struct PlayerView: View {
    let urn: String
    private let controller = SRGLetterboxController()
    
    var body: some View {
        VStack {
            LetterboxView(controller: controller)
                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
            Spacer()
        }
        .onAppear {
            controller.playURN(urn, at: nil, withPreferredSettings: nil)
        }
        .onDisappear {
            controller.reset()
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(urn: "urn:rts:video:11460386")
    }
}
