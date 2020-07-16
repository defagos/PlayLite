//
//  PlayerInfoView.swift
//  PlayLite
//
//  Created by Samuel Défago on 16.07.20.
//

import SRGLetterbox
import SwiftUI

class PlayerInfoData: ObservableObject {
    let controller: SRGLetterboxController
    
    @Published private(set) var mainMedia: SRGMedia?
    
    init(controller: SRGLetterboxController) {
        self.controller = controller
        
        NotificationCenter.default.addObserver(forName: Notification.Name.SRGLetterboxMetadataDidChange, object: controller, queue: nil) { _ in
            self.mainMedia = Self.mainMedia(for: controller)
        }
        self.mainMedia = Self.mainMedia(for: controller)
    }
    
    private static func mainMedia(for controller: SRGLetterboxController) -> SRGMedia? {
        if let mediaComposition = controller.mediaComposition {
            return mediaComposition.media(for: mediaComposition.mainChapter)
        }
        else {
            return controller.media
        }
    }
}

struct PlayerInfoView: View {
    @ObservedObject var data: PlayerInfoData
    
    init(controller: SRGLetterboxController) {
        data = PlayerInfoData(controller: controller)
    }
    
    var body: some View {
        if let media = data.mainMedia {
            MediaInfoView(media: media)
                .padding()
        }
    }
}

struct PlayerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerInfoView(controller: SRGLetterboxController())
    }
}
