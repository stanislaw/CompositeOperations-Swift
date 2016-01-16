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
    case Finished
}

class SimpleOperation: NSOperation, Operation {
    var result: OperationResult? = nil

    private var state: OperationState = .Ready

    final override var finished: Bool {
        return state == .Finished
    }

    final override func start() {
        finishWithResult(NSNull())
    }

    final func finishWithResult(result: AnyObject) {
        self.result = .Result(result)
        state = .Finished
    }

    final func rejectWithError(error: AnyObject) {
        self.result = .Error(error)
        state = .Finished
    }
}
