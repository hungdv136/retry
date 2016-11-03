//
//  Retriable.swift
//  Retry
//
//  Created by Chu Cuoi on 11/3/16.
//  Copyright © 2016 Chu Cuoi. All rights reserved.
//
import RxSwift

protocol Retriable {
    func handleError(error: Error, retriedCount: Int) -> Observable<Void>
    func retry(attempts: Observable<Error>) -> Observable<Void>
}
