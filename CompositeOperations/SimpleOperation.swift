//
//  SimpleOperation.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation

public class SimpleOperation: AbstractOperation {
    public var completion: ((OperationResult) -> Void)?

    final public func finish(result: OperationResult) {
        if cancelled == false {
            state = .Finished(result)
        } else {
            state = .Finished(.Cancelled)
        }

        if let completion = completion {
            completion(result)
        }
    }

    public override func main() {
        finish(.Result(NSNull()))
    }
}
