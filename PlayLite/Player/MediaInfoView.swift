//
//  MediaInfoView.swift
//  PlayLite
//
//  Created by Samuel Défago on 16.07.20.
//

import SRGDataProviderCombine
import SRGDataProviderNetwork       // TODO: Can probably be removed by writing the preview code with Combine
import SwiftUI

struct MediaInfoView: View {
    let media: SRGMedia
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    private static func viewCount(for media: SRGMedia) -> Int? {
        guard let viewSocialCount = media.socialCounts?.filter({ $0.type == .srgView }) else { return nil }
        return viewSocialCount.first?.value
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20.0) {
                Text(media.title)
                    .font(.headline)
                    .bold()
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                HStack(spacing: 20.0) {
                    Text(Self.dateFormatter.string(from: media.date))
                        .font(.caption)
                    if let viewCount = Self.viewCount(for: media) {
                        HStack {
                            Image(systemName: "eye")
                            Text("\(viewCount) views")
                                .font(.caption)
                        }
                    }
                }
                if let summary = media.summary {
                    Text(summary)
                        .font(.body)
                }
            }
        }
    }
}

struct MediaInfoView_Previews: PreviewProvider {
    static var sampleMedias: [SRGMedia]? = {
        let dataProvider = SRGDataProvider(serviceURL: SRGIntegrationLayerProductionServiceURL())
        var sampleMedias: [SRGMedia]?
        
        let group = DispatchGroup()
        group.enter()
        dataProvider.tvTrendingMedias(for: .RTS, withLimit: 10) { medias, _, _ in
            sampleMedias = medias
            group.leave()
        }.withOptions(.backgroundCompletionEnabled).resume()
        group.wait()
        return sampleMedias
    }()
    
    static var previews: some View {
        if let media = sampleMedias?.first {
            MediaInfoView(media: media)
                .padding()
        }
    }
}
