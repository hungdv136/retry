//
//  Retriable.swift
//  Retry
//
//  Created by Chu Cuoi on 11/3/16.
//  Copyright © 2016 Chu Cuoi. All rights reserved.
//
import RxSwift

protocol RetryDelegate {
    func handleError(error: Error, retriedCount: Int) -> Observable<Void>
    func retryWhen(attempts: Observable<Error>, filter: ErrorFilter) -> Observable<Void>
}

protocol ErrorFilter {
    func valid(error: Error) -> Bool
}
