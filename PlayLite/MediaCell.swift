//
//  MediaCell.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import FetchImage
import SRGAppearance
import SwiftUI

struct Media {
    let name: String
    let imageUrl: URL
    let date: Date
}

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

struct MediaCell: View {
    var media: Media
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    var body: some View {
        VStack {
            ImageView(url: media.imageUrl)
                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fill)
            VStack {
                Text(media.name)
                    .font(.headline)
                Text(Self.dateFormatter.string(from: media.date))
                    .font(.subheadline)
            }
        }
    }
}

struct MediaCell_Previews: PreviewProvider {
    static var previews: some View {
        let imageUrl = URL(string: "https://www.rts.ch/2020/07/13/17/11/10721864.image/16x9/scale/width/800")!
        let media = Media(name: "Pardonnez-moi", imageUrl: imageUrl, date: Date())
        MediaCell(media: media)
            .padding()
            .previewLayout(.fixed(width: 320, height: 220))
    }
}
