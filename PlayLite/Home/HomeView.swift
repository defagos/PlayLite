//
//  HomeView.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import SRGDataProvider
import SwiftUI

class HomeModel: ObservableObject {
    @Published private(set) var trendingMedias: [SRGMedia]?
    @Published private(set) var mostSeenMedias: [SRGMedia]?
    @Published private(set) var soonExpiringMedias: [SRGMedia]?
    
    private let requestQueue: SRGRequestQueue
    
    init() {
        self.requestQueue = SRGRequestQueue.init()
        self.refresh()
    }
    
    private func refresh() {
        let trendingMediasRequest = SRGDataProvider.current?.tvTrendingMedias(for: .RTS, withLimit: 20, completionBlock: { (medias, _, error) in
            self.requestQueue.reportError(error)
            self.trendingMedias = medias
        })
        if let trendingMediasRequest = trendingMediasRequest {
            self.requestQueue.add(trendingMediasRequest, resume: true)
        }
        
        let mostSeenMediasRequest = SRGDataProvider.current?.tvMostPopularMedias(for: .RTS, withCompletionBlock: { (medias, _, _, _, error) in
            self.requestQueue.reportError(error)
            self.mostSeenMedias = medias
        }).withPageSize(20)
        if let mostSeenMediasRequest = mostSeenMediasRequest {
            self.requestQueue.add(mostSeenMediasRequest, resume: true)
        }
        
        let soonExpiringMediasRequest = SRGDataProvider.current?.tvSoonExpiringMedias(for: .RTS, withCompletionBlock: { (medias, _, _, _, error) in
            self.requestQueue.reportError(error)
            self.soonExpiringMedias = medias
        })
        if let soonExpiringMediasRequest = soonExpiringMediasRequest {
            self.requestQueue.add(soonExpiringMediasRequest, resume: true)
        }
    }
    
    deinit {
        self.requestQueue.cancel()
    }
}

struct MediaSwimlane: View {
    let title: String
    let medias: [SRGMedia]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.title)
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(medias, id: \.uid) { media in
                        MediaCell(media: media)
                    }
                }
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

struct HomeView: View {
    @StateObject var model = HomeModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                if let medias = model.trendingMedias {
                    MediaSwimlane(title: "Trending", medias: medias)
                }
                if let medias = model.mostSeenMedias {
                    MediaSwimlane(title: "Most seen", medias: medias)
                }
                if let medias = model.soonExpiringMedias {
                    MediaSwimlane(title: "Soon expiring", medias: medias)
                }
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
