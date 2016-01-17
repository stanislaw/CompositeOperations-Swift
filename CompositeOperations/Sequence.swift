//
//  Sequence.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation

public protocol Sequence {
    func nextOperation(previousOperation: Operation?) -> Operation?
}

public class LinearSequence: Sequence {
    var currentStep = -1

    public var steps: [(Operation?) -> Operation?] {
        return []
    }

    public final func nextOperation(previousOperation: Operation?) -> Operation? {

        // linear sequence works only with successful operations
        if let previousOperation = previousOperation {
            if let previousResult = previousOperation.result {
                switch previousResult {
                    case .Result(_):
                        break
                    default:
                        return nil
                }
            } else {
                return nil
            }
        }

        currentStep++

        if currentStep < steps.count {
            let nextOperation = steps[currentStep](previousOperation)

            return nextOperation
        }

        return nil
    }
}