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
    let media: SRGMedia?
    
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
    
    private var title: String {
        guard let media = media else { return String(repeating: " ", count: .random(in: 15..<30)) }
        return media.title
    }
    
    private var dateString: String {
        guard let media = media else { return String(repeating: " ", count: .random(in: 10..<15)) }
        return Self.dateFormatter.string(from: media.date)
    }
    
    private var durationString: String {
        guard let media = media else { return "     " }
        return format(duration: media.duration / 1000)
    }
    
    private var imageUrl: URL? {
        return media?.imageURL(for: .height, withValue: 200.0, type: .default)
    }
    
    private var isPlaceholder: Bool {
        return media == nil
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                ImageView(url: imageUrl)
                    .whenRedacted { $0.hidden() }
                    .aspectRatio(CGSize(width: 16.0, height: 9.0), contentMode: .fit)
                    .background(Color.init(white: 0.0, opacity: 0.1))
                    .cornerRadius(3.0)
                    .layoutPriority(1)
                Text(durationString)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.all, 3.0)
                    .background(Color.init(white: 0, opacity: 0.6))
                    .cornerRadius(3.0)
                    .padding([.trailing, .bottom], 5.0)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .lineLimit(2)
                    Text(dateString)
                        .font(.subheadline)
                        .layoutPriority(1)
                }
                Spacer()
            }
        }
        .redacted(reason: isPlaceholder ? .placeholder : .init())
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
