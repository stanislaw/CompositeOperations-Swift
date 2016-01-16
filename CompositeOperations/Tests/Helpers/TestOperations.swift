//
//  TestOperations.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation
@testable import CompositeOperations

class TestOperation_NeverFinishes: SimpleOperation {
    override func main() {
    }
}

class TestOperation_FinishesWithNSNull: SimpleOperation {
    override func main() {
        finish(.Result(NSNull()))
    }
}

class TestSequence_Null: Sequence {
    func nextOperation(previousOperation: Operation?) -> Operation? {
        return nil
    }
}

class TestSequence_OneSimpleOperation: Sequence {
    func nextOperation(previousOperation: Operation?) -> Operation? {
        if let _ = previousOperation {
            return nil
        }

        return TestOperation_FinishesWithNSNull()
    }
}
