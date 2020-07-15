//
//  SceneDelegate.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.makeKeyAndVisible()
            
            window.rootViewController = UIHostingController(rootView: HomeView())
            self.window = window
        }
    }
}
