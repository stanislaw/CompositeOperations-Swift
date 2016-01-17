//
//  ParallelOperation.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 17/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation

internal class ParallelOperation : CompositeOperation {
    private let operations: [AbstractOperation]
    private let operationQueue: NSOperationQueue

    init(_ operations: [AbstractOperation], operationQueue: NSOperationQueue? = nil) {
        self.operations = operations

        if let operationQueue = operationQueue {
            self.operationQueue = operationQueue
        } else {
            let operationQueue = NSOperationQueue()
            operationQueue.maxConcurrentOperationCount = 4

            self.operationQueue = operationQueue
        }
    }

    private final func cancelAllOperations() {
        for operation in operations {
            operation.cancel()
        }
    }

    private final func finish(result: CompositeOperationResult) {
        state = .Finished(.Result(result))

        if let completion = completion {
            completion(result)
        }
    }

    private final func _finish() {
        if self.cancelled {
            self.finish(.Cancelled)
            return
        }

        var allOperationsSuccessful = true

        for operation in operations {
            if let result = operation.result {
                switch result {
                    case .Result(_):
                        break
                    default:
                        allOperationsSuccessful = false
                }
            } else {
                // TODO: throw here
                abort()
            }
        }

        let result: CompositeOperationResult
        if allOperationsSuccessful {
            let results = operations.map({ (operation) -> OperationResult in
                return operation.result!
            })

            result = .Results(results)
            finish(result)
        } else {
            let errors = operations.map({ (operation) -> OperationResult? in
                return operation.result
            })

            result = .Errors(errors)
            finish(result)
        }
    }

    final override func main() {
        let group = dispatch_group_create()

        for operation in operations {
            dispatch_group_enter(group)

            operation.completionBlock = { () in
                if let result = operation.result {
                    switch result {
                        case .Result(_):
                            break
                        default:
                            self.cancelAllOperations()
                    }
                }

                dispatch_group_leave(group);
            }
        }

        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self._finish()
        })

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
}
