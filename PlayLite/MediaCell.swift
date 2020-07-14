//
//  MediaCell.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import FetchImage
import SRGAppearance
import SRGDataProvider
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

struct MediaCell: View {
    var media: SRGMedia
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    var body: some View {
        VStack {
            if let imageUrl = media.imageURL(for: .height, withValue: 200, type: .default) {
                ImageView(url: imageUrl)
                    .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
            }
            VStack {
                Text(media.title)
                    .font(.headline)
                Text(Self.dateFormatter.string(from: media.date))
                    .font(.subheadline)
            }
        }
    }
}

struct MediaCell_Previews: PreviewProvider {
    static var sampleMedias: [SRGMedia] = {
        let dataProvider = SRGDataProvider(serviceURL: SRGIntegrationLayerProductionServiceURL())
        var sampleMedias: [SRGMedia] = []
        
        let group = DispatchGroup()
        group.enter()
        dataProvider.tvTrendingMedias(for: .RTS, withLimit: 10) { (medias, _, _) in
            sampleMedias = medias ?? []
            group.leave()
        }.withOptions(.backgroundCompletionEnabled).resume()
        group.wait()
        return sampleMedias
    }()
    
    static var previews: some View {
        if let media = sampleMedias.first {
            MediaCell(media: media)
                .previewLayout(.sizeThatFits)
        }
    }
}
