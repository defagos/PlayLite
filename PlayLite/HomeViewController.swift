//
//  HomeViewController.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import SwiftUI

class HomeViewController: UIHostingController<HomeView> {
    
    // MARK: Object lifecycle
    
    init() {
        super.init(rootView: HomeView())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: HomeView())
    }
}
