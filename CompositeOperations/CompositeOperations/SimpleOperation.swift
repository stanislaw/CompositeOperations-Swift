//
//  SimpleOperation.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation

enum OperationState {
    case Ready
    case Executing
    case Finished(OperationResult)
}

class SimpleOperation: NSOperation, Operation {
    var completion: ((OperationResult) -> Void)?

    private var state: OperationState = .Ready

    final override var executing: Bool {
        switch state {
            case .Executing:
                return true
            default:
                return false
            }
    }

    final override var finished: Bool {
        switch state {
            case .Finished(_):
                return true
            default:
                return false
        }
    }

    final var result: OperationResult? {
        switch state {
            case .Finished(let result):
                return result
            default:
                return nil
        }
    }

    final override func start() {
        if ready {
            state = .Executing;

            if cancelled {
                state = .Finished(.Cancelled)
            } else {
                self.main()
            }
        }
    }

    final func finishWithResult(result: AnyObject) {
        let operationResult: OperationResult

        if cancelled == false {
            operationResult = .Result(result)
            state = .Finished(operationResult)
        } else {
            operationResult = .Cancelled
            state = .Finished(operationResult)
        }

        if let completion = completion {
            completion(operationResult)
        }
    }

    final func rejectWithError(error: AnyObject) {
        if cancelled == false {
            state = .Finished(.Error(error))
        } else {
            state = .Finished(.Cancelled)
        }
    }

    override func main() {
        finishWithResult(NSNull())
    }
}
