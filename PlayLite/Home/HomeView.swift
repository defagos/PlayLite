//
//  HomeView.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import SRGDataProvider
import SwiftUI

struct HomeRow: Identifiable {
    let id: String
    let title: String
    let medias: [SRGMedia]
}

class HomeModel: ObservableObject {
    @Published private(set) var rows: [HomeRow] = []
    
    private let requestQueue: SRGRequestQueue
    
    init() {
        self.requestQueue = SRGRequestQueue.init()
        self.refresh()
    }
    
    private func loadTrendingMedias() {
        if let request = SRGDataProvider.current?.tvTrendingMedias(for: .RTS, withLimit: 20, editorialLimit: 3, episodesOnly: false, completionBlock: { (medias, _, error) in
            self.requestQueue.reportError(error)
            
            if let medias = medias {
                self.rows.append(HomeRow(id: "trending", title: "Trending now", medias: medias))
            }
        }) {
            self.requestQueue.add(request, resume: true)
        }
    }
    
    private func loadMostSeenMedias() {
        if let request = SRGDataProvider.current?.tvMostPopularMedias(for: .RTS, withCompletionBlock: { (medias, _, _, _, error) in
            self.requestQueue.reportError(error)
            
            if let medias = medias {
                self.rows.append(HomeRow(id: "popular", title: "Most popular", medias: medias))
            }
        }).withPageSize(20) {
            self.requestQueue.add(request, resume: true)
        }
    }
    
    private func loadSoonExpiringMedias() {
        if let request = SRGDataProvider.current?.tvSoonExpiringMedias(for: .RTS, withCompletionBlock: { (medias, _, _, _, error) in
            self.requestQueue.reportError(error)
            
            if let medias = medias {
                self.rows.append(HomeRow(id: "expiring", title: "Soon expiring", medias: medias))
            }
        }).withPageSize(20) {
            self.requestQueue.add(request, resume: true)
        }
    }
    
    private func loadTopicsMedias() {
        if let request = SRGDataProvider.current?.tvTopics(for: .RTS, withCompletionBlock: { (topics, _, error) in
            self.requestQueue.reportError(error)
            
            topics?.forEach { topic in
                if let request = SRGDataProvider.current?.latestMediasForTopic(withURN: topic.urn, completionBlock: { (medias, _, _, _, error) in
                    self.requestQueue.reportError(error)
                    
                    if let medias = medias {
                        self.rows.append(HomeRow(id: topic.urn, title: topic.title, medias: medias))
                    }
                }).withPageSize(20) {
                    self.requestQueue.add(request, resume: true)
                }
            }
        }) {
            self.requestQueue.add(request, resume: true)
        }
    }
    
    // FIXME: Order is not guaranteed
    private func refresh() {
        loadTrendingMedias()
        loadMostSeenMedias()
        loadSoonExpiringMedias()
        loadTopicsMedias()
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
                .font(.title2)
                .padding(.leading)
                .padding(.trailing)
            ScrollView(.horizontal) {
                HStack(spacing: 10.0) {
                    ForEach(medias, id: \.uid) { media in
                        MediaCell(media: media)
                    }
                }
                .padding(.leading)
                .padding(.trailing)
            }
        }
    }
}

struct HomeView: View {
    @StateObject var model = HomeModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40.0) {
                ForEach(model.rows) { row in
                    MediaSwimlane(title: row.title, medias: row.medias)
                }
                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Videos")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
