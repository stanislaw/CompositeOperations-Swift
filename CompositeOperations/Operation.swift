//
//  Operation.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation

enum OperationResult {
    case Result(Any)
    case Error(Any)
    case Cancelled
}

protocol Operation {
    var result: OperationResult? { get }

    var completionBlock: (() -> Void)? { get set }

    func start()
    func cancel()
}
