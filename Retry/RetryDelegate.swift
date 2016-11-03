//
//  Retriable.swift
//  Retry
//
//  Created by Chu Cuoi on 11/3/16.
//  Copyright © 2016 Chu Cuoi. All rights reserved.
//
import RxSwift

protocol RetryDelegate {
    func retryWhen(attempts: Observable<Error>, filter: ErrorFilter) -> Observable<Void>
}

protocol ErrorFilter {
    func valid(error: Error) -> Bool
}
