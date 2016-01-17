//
//  Unit_CompositeOperation_Tests.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 17/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import XCTest

@testable import CompositeOperations

class Unit_CompositeOperation_SequentialOperation_SuccessCase_Tests: XCTestCase {
    func test_should_finish_when_started() {
        let sequence = TestSequence_ThreeOperationsFinishingWithNull()

        let compositeOperation = CompositeOperation.sequential(sequence)

        waitForCompletion({ (done) -> Void in
            compositeOperation.completion = { (result) in
                done()
            }

            compositeOperation.start()
        })

        XCTAssertTrue(compositeOperation.finished)
    }

    func test_should_finish_with_result_array_of_3_nsnulls() {
        let sequence = TestSequence_ThreeOperationsFinishingWithNull()

        let compositeOperation = CompositeOperation.sequential(sequence)

        var expectedResult: CompositeOperationResult? = nil

        waitForCompletion({ (done) -> Void in
            compositeOperation.completion = { (result) in
                expectedResult = result

                done()
            }

            compositeOperation.start()
        })

        switch expectedResult! {
        case .Results(let results):
            XCTAssertEqual(results.count, 3)

            for result in results {
                switch result {
                case .Result(let result):
                    XCTAssert(result as! NSNull == NSNull())
                default:
                    XCTFail()
                }
            }

        default:
            XCTFail()
        }
    }
}

class Unit_CompositeOperation_Parallel_SuccessCase_Tests: XCTestCase {

    func test_should_finish_when_started() {
        let operations = [
            TestOperation_FinishesWithResult_NSNull(),
            TestOperation_FinishesWithResult_NSNull(),
            TestOperation_FinishesWithResult_NSNull()
        ]

        let parallelOperation = CompositeOperation.parallel(operations)

        waitForCompletion({ (done) -> Void in
            parallelOperation.completion = { (result) in
                done()
            }

            parallelOperation.start()
        })

        XCTAssertTrue(parallelOperation.finished)
    }

    func test_completion_should_have_array_with_NSNull() {
        let operations = [
            TestOperation_FinishesWithResult_NSNull(),
            TestOperation_FinishesWithResult_NSNull(),
            TestOperation_FinishesWithResult_NSNull()
        ]

        let parallelOperation = CompositeOperation.parallel(operations)

        var expectedResult: CompositeOperationResult? = nil

        waitForCompletion({ (done) -> Void in
            parallelOperation.completion = { (result) in
                expectedResult = result

                done()
            }

            parallelOperation.start()
        })

        switch expectedResult! {
        case .Results(let results):
            let firstResult = results.first!

            switch firstResult {
            case .Result(let result):
                XCTAssert(result as! NSNull == NSNull())
            default:
                XCTFail()
            }

        case .Errors(_):
            XCTFail()

        default:
            XCTFail()
        }
    }
}
