//
//  CardTransitionManager.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import Foundation
import UIKit

struct CardViewPresentationData {
    
    var rect: CGRect?
    var radius: CGFloat?
    weak var view: UIView?
    var trueRect: CGRect
    
    init(view: UIView?, rect: CGRect?, radius: CGFloat?) {
        self.rect = rect
        self.radius = radius
        self.view = view
        trueRect = view!.frameToWindow(withoutTransform: true) ?? .zero
    }
}

class CardTransitionManager: NSObject {
    static let shared = CardTransitionManager()
    private var data: CardViewPresentationData!
    private let transitionDurationForPresent: TimeInterval = 0.8
    private let transitionDurationForDismiss: TimeInterval = 0.4
    
    private override init() {}
    
    func configure(with data: CardViewPresentationData) {
        self.data = data
    }
    
    public func clearData() {
        self.data = nil
    }
    
}

// Bind everything together
extension CardTransitionManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPresentAnimator(data: data, duration: transitionDurationForPresent)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardDismissAnimator(data: data, duration: transitionDurationForDismiss)
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // TODO: - check this
        return nil
    }
}





