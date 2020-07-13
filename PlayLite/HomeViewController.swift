//
//  HomeViewController.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import SRGDataProvider
import SwiftUI

class HomeViewController: UIHostingController<HomeView> {
    var request: SRGBaseRequest?
    
    // MARK: Object lifecycle
    
    init() {
        super.init(rootView: HomeView())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: HomeView())
    }
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParent || self.isBeingDismissed {
            self.request?.cancel()
        }
    }
    
    // MARK: Data
    
    private func refresh() {
        request = SRGDataProvider.current?.tvLatestMedias(for: .RTS, withCompletionBlock: { (medias, page, nextPage, response, error) in
            if let medias = medias {
                print("Medias: \(medias)")
            }
        })
        request?.resume()
    }
}
