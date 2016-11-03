//
//  ViewController.swift
//  Retry
//
//  Created by Hung Dinh Van on 11/3/16.
//  Copyright © 2016 ChuCuoi. All rights reserved.
//
import UIKit

extension UIViewController {
    static var topMostController: UIViewController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var topController = appDelegate?.window?.rootViewController
        
        while let controller = topController?.presentedViewController {
            topController = controller
        }
        return topController
    }
}
