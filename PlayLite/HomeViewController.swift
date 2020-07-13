//
//  HomeViewController.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import SwiftUI

class HomeViewController: UIHostingController<ContentView> {
    init() {
        super.init(rootView: ContentView())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ContentView())
    }
}
