//
//  HomeView.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import Combine
import SRGDataProvider
import SwiftUI

struct HomeRow: Identifiable {
    let id: String
    let title: String
    let medias: [SRGMedia]
}

class HomeModel: ObservableObject {
    @Published private(set) var rows: [HomeRow] = []
    var cancellable: AnyCancellable?
    
    func refresh() {
        cancellable = Publishers.CombineLatest3(trendingMedias(), mostPopularMedias(), soonExpiringMedias())
            .map { combined -> [HomeRow] in
                let trendingRow = HomeRow(id: "trending", title: "Trending now", medias: combined.0)
                let mostPopularRow = HomeRow(id: "popular", title: "Most popular", medias: combined.1)
                let soonExpiringRow = HomeRow(id: "expiring", title: "Soon expiring", medias: combined.2)
                return [trendingRow, mostPopularRow, soonExpiringRow]
            }
            .replaceError(with: [])
            .assign(to: \.rows, on: self)
    }
    
    private func trendingMedias() -> Future<[SRGMedia], Error> {
        return Future { promise in
            let request = SRGDataProvider.current!.tvTrendingMedias(for: .RTS, withLimit: 20, editorialLimit: 3, episodesOnly: false) { medias, _, error in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    promise(.success(medias!))
                }
            }
            request.resume()
        }
    }
    
    private func mostPopularMedias() -> Future<[SRGMedia], Error> {
        return Future { promise in
            let request = SRGDataProvider.current!.tvMostPopularMedias(for: .RTS) { medias, _, _, _, error in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    promise(.success(medias!))
                }
            }
            request.resume()
        }
    }
    
    private func soonExpiringMedias() -> Future<[SRGMedia], Error> {
        return Future { promise in
            let request = SRGDataProvider.current!.tvSoonExpiringMedias(for: .RTS) { medias, _, _, _, error in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    promise(.success(medias!))
                }
            }
            request.resume()
        }
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
                    MediaSwimlane(title: row.title, medias: row.medias)
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
