//
//  Unit_ParallelOperation_Tests.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 17/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import XCTest
@testable import CompositeOperations

class ParallelOperation_InitialState_Tests: XCTestCase {
    let parallelOperation = ParallelOperation([])

    func test_should_be_ready() {
        XCTAssert(parallelOperation.ready)
    }

    func test_should_not_be_executing() {
        XCTAssertFalse(parallelOperation.executing)
    }

    func test_should_not_be_finished() {
        XCTAssertFalse(parallelOperation.finished)
    }
}

class ParallelOperation_ManyOperations_SuccessCase_Tests: XCTestCase {
    func test_should_finish_when_started() {
        let operations = [
            TestOperation_FinishesWithResult_NSNull(),
            TestOperation_FinishesWithResult_NSNull(),
            TestOperation_FinishesWithResult_NSNull()
        ]

        let parallelOperation = ParallelOperation(operations)

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

        let parallelOperation = ParallelOperation(operations)

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

class ParallelOperation_ManyOperations_FailureCase_Tests: XCTestCase {
    func test_should_finish_when_started() {
        let operations = [
            TestOperation_FinishesWithError_NSNull(),
            TestOperation_FinishesWithError_NSNull(),
            TestOperation_FinishesWithError_NSNull()
        ]

        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 1

        let parallelOperation = ParallelOperation(operations, operationQueue: operationQueue)

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
            TestOperation_FinishesWithError_NSNull(),
            TestOperation_FinishesWithError_NSNull(),
            TestOperation_FinishesWithError_NSNull()
        ]

        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 1

        let parallelOperation = ParallelOperation(operations, operationQueue: operationQueue)

        var expectedResult: CompositeOperationResult? = nil

        waitForCompletion({ (done) -> Void in
            parallelOperation.completion = { (result) in
                expectedResult = result

                done()
            }

            parallelOperation.start()
        })

        switch expectedResult! {
        case .Errors(let errors):
            XCTAssertEqual(errors.count, 3)
            let firstError = errors.first!

            switch firstError! {
                case .Error(let error):
                    XCTAssert(error as! NSNull == NSNull())
                default:
                    XCTFail()
                }

            for var i = 1; i < 3; i++ {
                let error = errors[i]

                switch error! {
                    case .Cancelled:
                        XCTAssertTrue(true)

                    case .Error(let error):
                        XCTAssert(error as! NSNull == NSNull())

                    default:
                        XCTFail()
                    }
            }
        case .Results(_):
            XCTFail()

        default:
            XCTFail()
        }
    }
}
