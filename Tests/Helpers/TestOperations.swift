//
//  TestOperations.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation
@testable import CompositeOperations

// MARK: - Operations

class TestOperation_NeverFinishes: SimpleOperation {
    override func main() {
    }
}

class TestOperation_FinishesWithResult_NSNull: SimpleOperation {
    override func main() {
        finish(.Result(NSNull()))
    }
}

class TestOperation_FinishesWithError_NSNull: SimpleOperation {
    override func main() {
        finish(.Error(NSNull()))
    }
}

// MARK: - Sequences

class TestSequence_Null: Sequence {
    func nextOperation(previousOperation: Operation?) -> Operation? {
        return nil
    }
}

class TestSequence_OneOperationFinishingWithNull: Sequence {
    func nextOperation(previousOperation: Operation?) -> Operation? {
        if let _ = previousOperation {
            return nil
        }

        return TestOperation_FinishesWithResult_NSNull()
    }
}

class TestSequence_ThreeOperationsFinishingWithNull: Sequence {
    var index = 0

    func nextOperation(previousOperation: Operation?) -> Operation? {
        if index++ < 3 {
            return TestOperation_FinishesWithResult_NSNull()
        }

        return nil
    }
}

class TestSequence_ThreeOperations_ThirdFinishesWithError_Null: Sequence {
    var index = 0

    func nextOperation(previousOperation: Operation?) -> Operation? {
        if index < 2 {
            index++;
            return TestOperation_FinishesWithResult_NSNull()
        }

        if index == 2 {
            index++;
            return TestOperation_FinishesWithError_NSNull();
        }

        return nil
    }
}
