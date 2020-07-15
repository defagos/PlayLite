//
//  PlayerView.swift
//  PlayLite
//
//  Created by Samuel Défago on 16.07.20.
//

import SwiftUI

struct PlayerView: UIViewControllerRepresentable {
    let urn: String?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return PlayerViewController(urn: self.urn)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(urn: "urn:rts:video:11460386")
    }
}
