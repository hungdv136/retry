//
//  RetryViewController.swift
//  Created by Chu Cuoi on 11/3/16.
//  Copyright © 2016 ChuCuoi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PureLayout

final class RetryViewController: PopupViewController {
    typealias RetryHandler = () -> Void
    typealias CancelHandler = () -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx_retry.subscribe(onNext: { [weak self] in
            self?.dismiss(retry: true)
        }).addDisposableTo(self.disposeBag)
        
        rx_cancel.subscribe(onNext: { [weak self] in
            self?.dismiss(retry: false)
        }).addDisposableTo(self.disposeBag)
        
        if autoRetry {
            rx_countDown.subscribe(onCompleted: { [weak self] in
                self?.dismiss(retry: true)
            }).addDisposableTo(disposeBag)
        }
    }
    
    func addRetryHandler(handler: @escaping RetryHandler) {
        retryHandlers.append(handler)
    }
    
    func addCancelHandler(handler: @escaping CancelHandler) {
        cancelHandlers.append(handler)
    }
    
    private func dismiss(retry: Bool) {
        dismiss(animated: true) {
            if retry {
                self.retryHandlers.forEach { $0() }
            }
            else {
                self.cancelHandlers.forEach { $0() }
            }
        }
    }
    
    private var retryHandlers = [RetryHandler]()
    private var cancelHandlers = [CancelHandler]()
    private let disposeBag: DisposeBag! = DisposeBag()
}

