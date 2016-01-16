//
//  CompositeOperationsTests.swift
//  CompositeOperationsTests
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import XCTest
@testable import CompositeOperations

class TestOperation_NeverFinishes: SimpleOperation {
    override func main() {
    }
}

class SimpleOperationTests: XCTestCase {
}

// NSOperation's behavior
extension SimpleOperationTests {
    func test_NSOperation_should_be_ready() {
        let operation: SimpleOperation = SimpleOperation()

        XCTAssert(operation.ready)
    }

    func test_NSOperation_should_not_be_executing() {
        let operation: SimpleOperation = SimpleOperation()

        XCTAssertFalse(operation.executing)
    }

    func test_NSOperation_should_be_executing_after_start() {
        let operation: TestOperation_NeverFinishes = TestOperation_NeverFinishes()

        operation.start()

        XCTAssertTrue(operation.executing)
    }

    func test_NSOperation_should_be_finished_if_called_start() {
        let operation: SimpleOperation = SimpleOperation()

        operation.start()

        XCTAssert(operation.finished)
    }
}

// SimpleOperation: initial state
extension SimpleOperationTests {
    func test_completion_should_be_nil() {
        let operation: SimpleOperation = SimpleOperation()

        XCTAssertNil(operation.completion)
    }
}

// SimpleOperation: finish(.Result())
extension SimpleOperationTests {
    func test_finish_with_result_should_finish_operation() {
        let operation: SimpleOperation = SimpleOperation()

        operation.finish(.Result(NSNull()))

        XCTAssert(operation.finished)
    }

    func test_finish_with_result_should_finish_operation_with_given_result() {
        let operation: SimpleOperation = SimpleOperation()

        operation.finish(.Result(NSNull()))

        if let result = operation.result {
            switch result {
                case .Result(let result):
                    XCTAssert(result as! NSObject == NSNull())

                default:
                    XCTAssert(false)
            }
        } else {
            XCTAssert(false)
        }
    }
}

// SimpleOperation: finish(.Error(NSNull()))
extension SimpleOperationTests {
    func test_reject_with_error_should_finish_operation() {
        let operation: SimpleOperation = SimpleOperation()

        operation.finish(.Error(NSNull()))

        XCTAssert(operation.finished)
    }

    func test_reject_with_error_should_finish_operation_with_given_error() {
        let operation: SimpleOperation = SimpleOperation()

        operation.finish(.Error(NSNull()))

        if let result = operation.result {
            switch result {
                case .Error(let error):
                    XCTAssert(error as! NSObject == NSNull())

                default:
                    XCTAssert(false)
            }
        } else {
            XCTAssert(false)
        }
    }
}

// SimpleOperation: cancel()
extension SimpleOperationTests {
    func test_cancel_then_reject_with_error_should_finish_operation_with_cancelled_state() {
        let operation: SimpleOperation = SimpleOperation()

        operation.cancel()

        operation.finish(.Error(NSNull()))

        if let result = operation.result {
            switch result {
            case .Cancelled:
                XCTAssert(true)

            default:
                XCTAssert(false)
            }
        } else {
            XCTAssert(false)
        }
    }
}

// SimpleOperation: @completion
extension SimpleOperationTests {
    func test_completion_should_be_invoked_as_last_step_of_finishWithResult() {
        let operation: SimpleOperation = SimpleOperation()

        var expectedResult: OperationResult? = nil

        operation.completion = { (result) in
            expectedResult = result
        }

        operation.start()

        if let result = expectedResult {
            switch result {
                case .Result(let result):
                    XCTAssert(result as! NSObject == NSNull())
                default:
                    XCTAssert(false)
            }
        } else {
            XCTAssert(false)
        }
    }
}
