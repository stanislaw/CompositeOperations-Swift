//
//  CompositeOperation.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 17/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation

enum CompositeOperationResult {
    case Results([OperationResult])
    case Errors([OperationResult?])
    case Cancelled
}

class CompositeOperation: AbstractOperation {
    var completion: ((CompositeOperationResult) -> Void)?

    class func sequential(sequence: Sequence) -> CompositeOperation {
        return SequentialOperation(sequence: sequence)
    }

    class func parallel(operations: [AbstractOperation], operationQueue: NSOperationQueue? = nil) -> CompositeOperation {
        return ParallelOperation(operations, operationQueue: operationQueue)
    }
}
