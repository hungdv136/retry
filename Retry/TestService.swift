//
//  TestService.swift
//  Retry
//
//  Created by Chu Cuoi on 11/3/16.
//  Copyright © 2016 ChuCuoi. All rights reserved.
//

import RxSwift

enum NetworkError: Error {
    case requestTimeout
}

final class TestService {
    init(retryDelegate: RetryDelegate?) {
        self.retryDelegate = retryDelegate
    }
    
    func createObservable() -> Observable<Void> {
        return Observable.create { o in
            o.onNext()
            o.onError(NetworkError.requestTimeout)
            return Disposables.create()
        }.retryWhen { (attempts: Observable<Error>) -> Observable<Void> in
            return self.retryDelegate?.retryWhen(attempts: attempts, filter: self.errorFilter) ?? attempts.map { _ in}
        }
    }
    
    private let retryDelegate: RetryDelegate?
    private let errorFilter = NetworkErrorFilter()
}

final class NetworkErrorFilter: ErrorFilter {
    func valid(error: Error) -> Bool {
        if case NetworkError.requestTimeout = error {
            return true
        }
        return false
    }
}
