//
//  PopupPresentationController.swift
//  Retry
//
//  Created by Hung Dinh Van on 11/3/16.
//  Copyright © 2016 ChuCuoi. All rights reserved.
//

import UIKit

final class PopupPresentationController: UIPresentationController {
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        dimmingView = UIView()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dimmingView.alpha = 0
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        if let containerView = containerView {
            presentingViewController.view.tintAdjustmentMode = .dimmed
            
            dimmingView.frame = containerView.bounds
            dimmingView.alpha = 0
            containerView.insertSubview(dimmingView, at: 0)
            
            if let transitionCoordinator = presentedViewController.transitionCoordinator {
                transitionCoordinator.animate(alongsideTransition: { context in
                    self.dimmingView.alpha = 1
                }, completion: nil)
            }
            else {
                dimmingView.alpha = 1
            }
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentingViewController.view.tintAdjustmentMode = .automatic
        
        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { context in
                self.dimmingView.alpha = 0
            }, completion: nil)
        }
        else {
            dimmingView.alpha = 0
        }
    }
    
    override var presentationStyle: UIModalPresentationStyle {
        return .overFullScreen
    }
    
    override func adaptivePresentationStyle(for traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .custom
    }
    
    override func containerViewWillLayoutSubviews() {
        if let containerView = containerView {
            dimmingView.frame = containerView.bounds
        }
        if let presentedView = presentedView {
            presentedView.frame = frameOfPresentedViewInContainerView
        }
    }
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero
        if let containerView = containerView {
            let containerBounds = containerView.bounds
            presentedViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
            presentedViewFrame.insetBy(dx: 25, dy: 30)
        }
        return presentedViewFrame
    }
    
    //MARK: Properties
    
    private let dimmingView: UIView
}
