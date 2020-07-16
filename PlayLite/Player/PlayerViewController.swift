//
//  PlayerViewController.swift
//  PlayLite
//
//  Created by Samuel Défago on 16.07.20.
//

import SRGLetterbox
import SwiftUI
import UIKit

class PlayerViewController: UIViewController {
    let urn: String?
    
    private let controller: SRGLetterboxController
    private weak var aspectRatioConstraint: NSLayoutConstraint?
    
    // MARK: Object lifecycle
    
    init(urn: String?) {
        self.urn = urn
        self.controller = SRGLetterboxController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.urn = nil
        self.controller = SRGLetterboxController()
        super.init(coder: coder)
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        
        let letterboxView = SRGLetterboxView()
        letterboxView.translatesAutoresizingMaskIntoConstraints = false
        letterboxView.controller = controller
        letterboxView.delegate = self
        view.addSubview(letterboxView)
        
        let aspectRatioConstraint = letterboxView.heightAnchor.constraint(equalTo: letterboxView.widthAnchor, multiplier: 1.0 / letterboxView.aspectRatio)
        NSLayoutConstraint.activate([
            letterboxView.topAnchor.constraint(equalTo: view.topAnchor),
            letterboxView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            letterboxView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            aspectRatioConstraint
        ])
        self.aspectRatioConstraint = aspectRatioConstraint
        
        let infoViewController = UIHostingController(rootView: PlayerInfoView())
        addChild(infoViewController)
        infoViewController.didMove(toParent: self)
        
        let infoView = infoViewController.view!
        infoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoView)
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: letterboxView.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isMovingToParent || self.isBeingPresented {
            if let urn = urn {
                controller.playURN(urn, at: nil, withPreferredSettings: nil)
            }
        }
    }
}

extension PlayerViewController: SRGLetterboxViewDelegate {
    func letterboxViewWillAnimateUserInterface(_ letterboxView: SRGLetterboxView) {
        view.layoutIfNeeded()
        letterboxView.animateAlongsideUserInterface { _, _, aspectRatio, heightOffset in
            self.aspectRatioConstraint = self.aspectRatioConstraint?.srg_replacementConstraint(withMultiplier: 1.0 / aspectRatio, constant: heightOffset)
            self.view.layoutIfNeeded()
        } completion: { _ in }
    }
}

struct PlayerViewController_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(urn: nil)
    }
}
