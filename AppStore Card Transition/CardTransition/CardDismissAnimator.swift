//
//  CardDismissAnimator.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import Foundation
import UIKit

class CardDismissAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
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
        guard let fromVC = transitionContext.viewController(forKey: .from)
            else {
                return
        }
        let ctx = transitionContext
        let toVC: UIViewController!
        toVC = ctx.viewController(forKey: .to)
        let containerView = ctx.containerView
        let fromView = fromVC.view!
        ctx.containerView.backgroundColor = fromView.backgroundColor
        fromView.clipsToBounds = true
        let maskView = UIView.init(frame: fromView.frame)
        maskView.backgroundColor = .black
        maskView.clipsToBounds = true
        containerView.mask = maskView
        var otherSubviews: [UIView]
        toVC.view.isHidden = false
        let cardView = fromVC.cardDestinationView ?? UIView()
        if let view = (fromVC as? UINavigationController)?.topViewController?.view {
            otherSubviews = view.subviews.filter {$0 !== cardView}
            otherSubviews.append((fromVC as! UINavigationController).navigationBar)
        } else {
            otherSubviews = fromView.subviews.filter {$0 !== cardView}
        }
        let cardViewFrame = cardView.superview?.convert(cardView.frame, to: nil)
        let cardViewSnapshot = data.view!.snapshotView(afterScreenUpdates: true)!
        let displayingCardView = cardView.snapshotView(afterScreenUpdates: true)!
        cardView.isHidden = true
        ctx.containerView.addSubview(blurView)
        blurView.frame = ctx.containerView.frame
        blurView.alpha = 1
        let fakeRect = CGRect(x: 0, y: 0, width: fromView.frame.width, height: data.view!.frame.height * 1.5)
        containerView.addSubview(fromView)
        containerView.addSubview(cardViewSnapshot)
        containerView.addSubview(displayingCardView)
        displayingCardView.frame = cardViewFrame ?? .zero
        cardViewSnapshot.frame = cardViewFrame ?? .zero
        cardViewSnapshot.layer.cornerRadius = data.radius ?? 0
        cardView.clipsToBounds = true
        cardViewSnapshot.alpha = 0
        data.view?.alpha = 0
        maskView.layer.masksToBounds = false
        toVC.viewWillAppear(true)
        fromVC.viewWillDisappear(true)
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: ctx), delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                maskView.layer.cornerRadius = self.data.radius!
                maskView.frame = self.data.trueRect
                displayingCardView.frame = self.data.trueRect
                cardViewSnapshot.frame = self.data.trueRect
                fromView.frame.origin.y = self.data.trueRect.origin.y
                if cardView.superview?.isKind(of: UIScrollView.self) == true  {
                    _ = otherSubviews.filter {$0 !== cardView.superview ?? UIView()}.map {$0.alpha = 0}
                } else {
                    _ = otherSubviews.map {$0.alpha = 0}
                }
                _ = otherSubviews.filter {$0.isKind(of: UIScrollView.self) == true}.map {$0.transform = CGAffineTransform.init(translationX: 0, y: -250)}
                ctx.containerView.layoutIfNeeded()
                
                displayingCardView.alpha = 0
                self.blurView.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                ctx.containerView.alpha = 0
                UIView.performWithoutAnimation {
                    self.data.view?.alpha = 1
                    self.data = nil
                    CardTransitionManager.shared.clearData()
                }
            })
        }) { (finished) in
            displayingCardView.removeFromSuperview()
            fromView.removeFromSuperview()
            cardViewSnapshot.removeFromSuperview()
            self.blurView.removeFromSuperview()
            toVC.viewDidAppear(true)
            fromVC.viewDidDisappear(true)
            
            fromVC.transitioningDelegate = nil
            ctx.completeTransition(true)
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: ctx), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            cardViewSnapshot.alpha = 1
        }) { (finished) in }
    }
    
    
}

