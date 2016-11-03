//
//  TestService.swift
//  Retry
//
//  Created by Chu Cuoi on 11/3/16.
//  Copyright © 2016 ChuCuoi. All rights reserved.
//

import RxSwift

final class TestService {
    init(retryDelegate: Retriable?) {
        self.retryDelegate = retryDelegate
    }
    
    func createObservable() -> Observable<Void> {
        return Observable.create { o in
            o.onNext()
            o.onError(RetriableError.retry)
            return Disposables.create()
        }.retryWhen { (attempts: Observable<Error>) -> Observable<Void> in
            return self.retryDelegate?.retry(attempts: attempts) ?? Observable.error(RetriableError.dismiss)
        }
    }
    
    private let retryDelegate: Retriable?
}
