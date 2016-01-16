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
    private var state: OperationState = .Ready

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
        finishWithResult(NSNull())
    }

    final func finishWithResult(result: AnyObject) {
        state = .Finished(.Result(result))
    }

    final func rejectWithError(error: AnyObject) {
        state = .Finished(.Error(error))
    }
}
