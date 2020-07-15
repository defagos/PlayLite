//
//  LetterboxView.swift
//  PlayLite
//
//  Created by Samuel Défago on 15.07.20.
//

import SRGLetterbox
import SwiftUI

struct LetterboxView: UIViewRepresentable {
    let controller: SRGLetterboxController?
    
    func makeUIView(context: Context) -> SRGLetterboxView {
        return SRGLetterboxView()
    }

    func updateUIView(_ uiView: SRGLetterboxView, context: Context) {
        uiView.controller = controller
    }
}

struct LetterboxView_Previews: PreviewProvider {
    static var previews: some View {
        LetterboxView(controller: nil)
            .previewLayout(.fixed(width: 480.0, height: 270.0))
    }
}
