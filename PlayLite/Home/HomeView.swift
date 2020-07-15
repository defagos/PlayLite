//
//  HomeView.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import SRGDataProvider
import SwiftUI

class HomeModel: ObservableObject {
    @Published private(set) var trending: [SRGMedia]?
    private var request: SRGBaseRequest?
    
    init() {
        self.refresh()
    }
    
    private func refresh() {
        request = SRGDataProvider.current?.tvTrendingMedias(for: .RTS, withLimit: 20, completionBlock: { (medias, _, _) in
            self.trending = medias
        })
        request?.resume()
    }
    
    deinit {
        self.request?.cancel()
    }
}

struct HomeView: View {
    @StateObject var model = HomeModel()
    
    var body: some View {
        ZStack {
            if let medias = model.trendingMedias {
                VStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(medias, id: \.uid) { media in
                                MediaCell(media: media)
                            }
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    }
                    Spacer()
                }
            }
            else {
                VStack {
                    Image(systemName: "film")
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                    Text("No medias")
                        .font(.title)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
