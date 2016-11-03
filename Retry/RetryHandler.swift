//
//  RetryHandler.swift
//  Retry
//
//  Created by Chu Cuoi on 11/3/16.
//  Copyright © 2016 ChuCuoi. All rights reserved.
//

import RxSwift

final class RetryHandler: Retriable {
    
    func handleError(error: Error, retriedCount: Int) -> Observable<Void> {
        return Observable.create { observer in
            
            if self.sharedPopupController == nil {
                self.sharedPopupController = RetryViewController(autoRetry: retriedCount <= 3)
            }
            
            self.sharedPopupController?.addRetryHandler {
                self.sharedPopupController = nil
                observer.onNext()
                observer.onCompleted()
            }
            
            self.sharedPopupController?.addCancelHandler {
                self.sharedPopupController = nil
                observer.onError(RetriableError.dismiss)
            }
            
            self.presentRetryModal()
            
            return Disposables.create()
        }
    }
    
    func retry(attempts: Observable<Error>) -> Observable<Void> {
        return attempts.scan(0) { (lastCount, error) -> Int in
            // depend on your bussiness, you can retry for other errors here
            guard case RetriableError.retry = error else { throw error }
            return lastCount + 1
        }.flatMap { count -> Observable<Void> in
            return self.handleError(error: RetriableError.retry, retriedCount: count)
        }
    }
    
    private func presentRetryModal() {
        guard let controller = sharedPopupController else { return }
        
        if controller.presentingViewController == nil {
            UIViewController.topMostController?.present(controller, animated: true, completion: nil)
        }
    }
    
    private weak var sharedPopupController: RetryViewController?
}
