//
//  CardPresentAnimator.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import Foundation
import UIKit

class CardPresentAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    private var data: CardViewPresentationData!
    private var animationDuration: TimeInterval!
    private let blurView: UIVisualEffectView = {
        let blurEffect: UIBlurEffect
        if #available(iOS 10.0, *) {
            blurEffect = UIBlurEffect(style: .prominent)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    init(data: CardViewPresentationData, duration: TimeInterval) {
        self.data = data
        self.animationDuration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let ctx = transitionContext
        let to = ctx.viewController(forKey: .to)
        let toView = to!.view!
        let from: UIViewController!
        from = ctx.viewController(forKey: .from)
        let rect = data.rect!
        let sourceViewSnapshot = data.view!.snapshotView(afterScreenUpdates: true)!
        sourceViewSnapshot.layer.cornerRadius = data.radius ?? data.view?.layer.cornerRadius ?? 0
        let mask = UIView(frame: toView.frame)
        mask.clipsToBounds = true
        mask.backgroundColor = .black
        toView.mask = mask
        ctx.containerView.backgroundColor = .clear
        data.view?.layer.removeAllAnimations()
        data.view?.isHidden = true
        let window = UIApplication.shared.keyWindow!
        to!.cardDestinationView?.alpha = 0
        blurView.frame = ctx.containerView.frame
        blurView.alpha = 0
        //        ctx.containerView.backgroundColor = toView.backgroundColor
        ctx.containerView.addSubview(blurView)
        let shadowView = UIView()
        ctx.containerView.addSubview(shadowView)
        ctx.containerView.addSubview(toView)
        ctx.containerView.addSubview(sourceViewSnapshot)
        sourceViewSnapshot.frame = data.rect!
        
        let otherSubviews: [UIView]
        let cardView = to!.cardDestinationView ?? UIView()
        
        if to is UINavigationController {
            otherSubviews = (to as! UINavigationController).topViewController?.view.subviews.filter {$0 !== cardView} ?? []
        } else {
            otherSubviews = toView.subviews.filter {$0 !== cardView}
        }
        if cardView.superview is UITableView {
            otherSubviews.removeAll(where: {$0 === cardView.superview ?? UIView()})
        }
        _ = otherSubviews.map {$0.alpha = 0}
        toView.frame = window.frame
        toView.frame.origin.y = rect.origin.y
        mask.frame = rect
        mask.frame.origin.y = 0
        mask.frame.size.height = rect.height
        mask.layer.cornerRadius = data.radius!
        shadowView.layer.cornerRadius = data.radius!
        shadowView.applyStandardShadow()
        shadowView.layer.shadowOpacity = 0.2
        shadowView.backgroundColor = .white
        shadowView.clipsToBounds = false
        shadowView.frame = rect
        mask.frame.size.height = rect.height
        mask.layer.masksToBounds = false
        from?.viewWillDisappear(true)
        to?.viewWillAppear(true)
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: ctx) / 2, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                mask.frame.size.height = ctx.containerView.frame.height
                shadowView.frame.size.height = ctx.containerView.frame.height
                mask.layer.cornerRadius = 0
                self.blurView.alpha = 1
                mask.frame.origin.x = ctx.containerView.frame.origin.x
                mask.frame.size.width = ctx.containerView.frame.width
                shadowView.frame.origin.x = ctx.containerView.frame.origin.x
                shadowView.frame.size.width = ctx.containerView.frame.width
                shadowView.layer.cornerRadius = 0
                shadowView.frame.origin.y = 0
                sourceViewSnapshot.frame.origin.x = ctx.containerView.frame.origin.x
                sourceViewSnapshot.frame.size.width = ctx.containerView.frame.size.width
                sourceViewSnapshot.frame.origin.y = to?.cardDestinationView?.frame.origin.y ?? 0
                _ = otherSubviews.map {$0.alpha = 1}
            })
        }) { (finished) in
            
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: ctx), delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.5, options: [], animations: {
            toView.frame.origin.y = 0
            mask.frame.origin.y = 0
            sourceViewSnapshot.alpha = 0
            to!.cardDestinationView?.alpha = 1
        }) { (finished) in
            to?.viewDidAppear(true)
            sourceViewSnapshot.removeFromSuperview()
            shadowView.removeFromSuperview()
            self.blurView.removeFromSuperview()
            from?.viewDidDisappear(true)
            ctx.completeTransition(!ctx.transitionWasCancelled)
            from.view.isHidden = true
            self.data.view?.isHidden = false
        }
        
    }
}
