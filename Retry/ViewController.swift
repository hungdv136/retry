//
//  ViewController.swift
//  Retry
//
//  Created by Hung Dinh Van on 11/3/16.
//  Copyright © 2016 ChuCuoi. All rights reserved.
//

import UIKit
import RxSwift

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 44))
        button.backgroundColor = UIColor.darkGray
        button.setTitle("Test", for: .normal)
        view.addSubview(button)
        
        button.rx.tap.flatMap { [weak self] in
            self?.testService.createObservable() ?? Observable.just()
        }.subscribe(onNext: { _ in
            print("onNext")
        }, onError: { error in
            print(error)
        }).addDisposableTo(disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let testService = TestService(retryDelegate: RetryHandler())
}

