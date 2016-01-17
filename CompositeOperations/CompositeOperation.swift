//
//  CompositeOperation.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 17/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation

public enum CompositeOperationResult {
    case Results([OperationResult])
    case Errors([OperationResult?])
    case Cancelled
}

public class CompositeOperation: AbstractOperation {
    public var completion: ((CompositeOperationResult) -> Void)?

    public class func sequential(sequence: Sequence) -> CompositeOperation {
        return SequentialOperation(sequence: sequence)
    }

    public class func parallel(operations: [AbstractOperation], operationQueue: NSOperationQueue? = nil) -> CompositeOperation {
        return ParallelOperation(operations, operationQueue: operationQueue)
    }
}
