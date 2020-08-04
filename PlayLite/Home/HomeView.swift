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
    enum Id : Equatable {
        case trending
        case latest
        case topics
        case latestForTopic(_ topic: SRGTopic)
    }
    
    let id: Id
    
    var title: String {
        switch id {
            case .trending:
                return "Trending now"
            case .latest:
                return "Latest videos"
            case .topics:
                return "Topics"
            case let .latestForTopic(topic):
                return topic.title
        }
    }
    
    func load() -> AnyCancellable? {
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
            case .topics:
                return nil
            case let .latestForTopic(topic):
                return dataProvider.latestMediasForTopic(withUrn: topic.urn)
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
    private static let rowIds: [HomeRow.Id] = [.trending, .latest, .topics]
    
    @Published private(set) var rows = [HomeRow]()
    var cancellables = Set<AnyCancellable>()
    
    func findRow(id: HomeRow.Id) -> HomeRow? {
        return rows.first(where: { $0.id == id })
    }
    
    func updateRows(topicRows: [HomeRow] = []) {
        var updatedRows = [HomeRow]()
        
        for id in Self.rowIds {
            if id == .topics {
                for row in topicRows {
                    if let existingRow = findRow(id: row.id) {
                        updatedRows.append(existingRow)
                    }
                    else {
                        updatedRows.append(row)
                    }
                }
            }
            else {
                if let existingRow = findRow(id: id) {
                    updatedRows.append(existingRow)
                }
                else {
                    updatedRows.append(HomeRow(id: id))
                }
            }
        }
        
        rows = updatedRows
    }
    
    init() {
        updateRows()
    }
    
    func refresh(rows: [HomeRow]) {
        for row in rows {
            if let cancellable = row.load() {
                cancellables.insert(cancellable)
            }
        }
    }
    
    func refresh() {
        cancellables = []
        self.refresh(rows: rows)
        
        SRGDataProvider.current!.tvTopics(for: .RTS)
            .map {
                return $0.0.map { HomeRow(id: .latestForTopic($0)) }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { topicRows in
                self.updateRows(topicRows: topicRows)
                self.refresh(rows: topicRows)
            }
            .store(in: &cancellables)
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
                LazyHStack(spacing: 10.0) {
                    if (row.medias.count > 0) {
                        ForEach(row.medias, id: \.uid) { media in
                            NavigationLink(destination: PlayerView(urn: media.urn)) {
                                MediaCell(media: media)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    else {
                        ForEach(0..<10) { _ in 
                            MediaCell(media: nil)
                        }
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
            LazyVStack(spacing: 40.0) {
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
