//
//  RootView.swift
//  PlayLite
//
//  Created by Samuel Défago on 15.07.20.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView() {
            HomeView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
