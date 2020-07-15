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
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private static let shortDurationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    private static let longDurationFormatter : DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second, .hour]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    private func format(duration: TimeInterval) -> String {
        if (duration <= 60.0 * 60.0) {
            return Self.shortDurationFormatter.string(from: duration)!
        }
        else {
            return Self.longDurationFormatter.string(from: duration)!
        }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                ImageView(url: media.imageURL(for: .height, withValue: 200.0, type: .default))
                    .aspectRatio(CGSize(width: 16.0, height: 9.0), contentMode: .fit)
                    .cornerRadius(3.0)
                    .layoutPriority(1)
                Text(format(duration: media.duration / 1000))
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.all, 3.0)
                    .background(Color.init(white: 0, opacity: 0.6))
                    .cornerRadius(3.0)
                    .padding([.trailing, .bottom], 5.0)
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
        .frame(width: 210.0, height: 190.0, alignment: .top)
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
