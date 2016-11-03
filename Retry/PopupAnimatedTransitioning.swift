//
//  PopupAnimatedTransitioning.swift
//  Retry
//
//  Created by Hung Dinh Van on 11/3/16.
//  Copyright © 2016 ChuCuoi. All rights reserved.
//

import UIKit

final class PopupAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromView = fromController.view,
            let toView = toController.view else {
                return
        }
        let containerView = transitionContext.containerView
        
        if isPresentation {
            containerView.addSubview(toView)
        }
        
        let animatingController = isPresentation ? toController : fromController
        let animatingView = animatingController.view
        let appearedFrame = transitionContext.finalFrame(for: animatingController)
        var dismissedFrame = appearedFrame
        dismissedFrame.origin.y += dismissedFrame.height + dismissedFrame.origin.x * 2
        
        let initialFrame = isPresentation ? dismissedFrame : appearedFrame
        let finalFrame = isPresentation ? appearedFrame : dismissedFrame
        animatingView?.frame = initialFrame
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: [isPresentation ? .curveEaseOut : .curveEaseIn], animations: {
            animatingView?.frame = finalFrame
        }, completion: { finished in
            if !self.isPresentation {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        })
    }
    
    //MARK: Properties
    
    private let isPresentation: Bool
}

