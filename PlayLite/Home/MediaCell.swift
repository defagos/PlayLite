//
//  MediaCell.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import SRGAppearance
import SRGDataProvider
import SwiftUI

struct MediaCell: View {
    let media: SRGMedia
    
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
                    .layoutPriority(1)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(media.title)
                        .font(.headline)
                        .lineLimit(2)
                    Text(Self.dateFormatter.string(from: media.date))
                        .font(.subheadline)
                        .layoutPriority(1)
                }
                Spacer()
            }
        }
        .frame(width: 210, height: 190, alignment: .top)
    }
}

struct MediaCell_Previews: PreviewProvider {
    static var sampleMedias: [SRGMedia]? = {
        let dataProvider = SRGDataProvider(serviceURL: SRGIntegrationLayerProductionServiceURL())
        var sampleMedias: [SRGMedia]?
        
        let group = DispatchGroup()
        group.enter()
        dataProvider.tvTrendingMedias(for: .RTS, withLimit: 10) { (medias, _, _) in
            sampleMedias = medias
            group.leave()
        }.withOptions(.backgroundCompletionEnabled).resume()
        group.wait()
        return sampleMedias
    }()
    
    static var previews: some View {
        if let media = sampleMedias?.first {
            MediaCell(media: media)
                .previewLayout(.sizeThatFits)
        }
    }
}
