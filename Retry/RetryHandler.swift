//
//  RetryHandler.swift
//  Retry
//
//  Created by Chu Cuoi on 11/3/16.
//  Copyright © 2016 ChuCuoi. All rights reserved.
//

import RxSwift

final class RetryHandler: RetryDelegate {
    
    struct ScanState {
        let count: Int
        let error: Error?
    }
    
    func retryWhen(attempts: Observable<Error>, filter: ErrorFilter) -> Observable<Void> {
        return attempts.scan(ScanState(count: 0, error: nil)) { (lastState, error) -> ScanState in
            return ScanState(count: lastState.count + 1, error: error)
        }.flatMap { state -> Observable<Void> in
            guard let error = state.error else { return Observable.just()}
            if !filter.valid(error: error) { throw error }
            return self.handleError(error: error, retriedCount: state.count)
        }
    }
    
    private func handleError(error: Error, retriedCount: Int) -> Observable<Void> {
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
                observer.onError(error)
            }
            
            self.presentRetryModal()
            
            return Disposables.create()
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


