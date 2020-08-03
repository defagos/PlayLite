//
//  HomeView.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import Combine
import SRGDataProvider
import SRGDataProviderCombine
import SwiftUI

class HomeRow: ObservableObject, Identifiable {
    enum Id {
        case trending
        case latest
    }
    
    let id: Id
    
    var title: String {
        switch id {
            case .trending:
                return "Trending now"
            case .latest:
                return "Latest videos"
        }
    }
    
    func load() -> AnyCancellable {
        let dataProvider = SRGDataProvider.current!
        switch id {
            case .trending:
                return dataProvider.tvTrendingMedias(for: .RTS)
                    .map { $0.0 }
                    .replaceError(with: [])
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.medias, on: self)
            case .latest:
                return dataProvider.tvLatestMedias(for: .RTS)
                    .map { $0.0 }
                    .replaceError(with: [])
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.medias, on: self)
        }
    }
    
    @Published var medias: [SRGMedia] = []
    
    init(id: Id) {
        self.id = id
    }
}

class HomeModel: ObservableObject {
    @Published private(set) var rows: [HomeRow] = {
        let trendingRow = HomeRow(id: .trending)
        let latestRow = HomeRow(id: .latest)
        return [trendingRow, latestRow]
    }()
    var cancellables = Set<AnyCancellable>()
    
    func refresh() {
        for row in rows {
            cancellables.insert(row.load())
        }
    }
}

struct MediaSwimlane: View {
    @ObservedObject var row: HomeRow
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(row.title)
                .font(.title2)
                .padding(.leading)
                .padding(.trailing)
            ScrollView(.horizontal) {
                HStack(spacing: 10.0) {
                    ForEach(row.medias, id: \.uid) { media in
                        NavigationLink(destination: PlayerView(urn: media.urn)) {
                            MediaCell(media: media)
                        }
                        .buttonStyle(PlainButtonStyle())
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
                    MediaSwimlane(row: row)
                }
                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Videos")
        .onAppear {
            model.refresh()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
