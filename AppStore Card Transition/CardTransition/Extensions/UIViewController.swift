//
//  UIViewController + PresentAsCard.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import Foundation
import UIKit

//MARK: - PresentAsCard
extension UIViewController {
    
    func presentAsCard(_ card: CardViewContainable, with data: CardViewPresentationData, faded: Bool = true, animated: Bool, completion:(() -> Void)?) {
        guard let vc = card as? UIViewController else {
            fatalError("YOU CANNOT PRESENT BECAUSE \(card.self) != \(UIViewController.self)")
        }
        //        guard let destView = card.cardDestinationView else {
        //            fatalError("destination VC not contained destinationCardView or its nil at the time, please override func cartDestinationView() -> UIView? in \(card.self)")
        //        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = CardTransitionManager.shared
        CardTransitionManager.shared.configure(with: data)
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: animated, completion: completion)
    }
}

//MARK: - CardViewContainable Extension
extension UIViewController: CardViewContainable {
    @objc var cardDestinationView: UIView! {
        if self is UINavigationController {
            return (self as! UINavigationController).visibleViewController?.cardDestinationView
        }
        return nil
    }
}
