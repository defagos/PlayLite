//
//  File.swift
//  PlayLite
//
//  Created by Samuel Défago on 15.07.20.
//

import FetchImage
import SwiftUI

struct ImageView: View {
    @ObservedObject var image: FetchImage
    
    init(url: URL) {
        image = FetchImage(url: url)
    }

    public var body: some View {
        ZStack {
            Rectangle().fill(Color.black)
            image.view?
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .animation(.default)
        .onAppear(perform: image.fetch)
        .onDisappear(perform: image.cancel)
    }
}

