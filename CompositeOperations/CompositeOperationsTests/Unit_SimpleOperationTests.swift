//
//  CompositeOperationsTests.swift
//  CompositeOperationsTests
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import XCTest
@testable import CompositeOperations

class SimpleOperationTests: XCTestCase {
}

// NSOperation's behavior
extension SimpleOperationTests {
    func test_NSOperation_should_be_ready() {
        let operation: SimpleOperation = SimpleOperation()

        XCTAssert(operation.ready)
    }

    func test_NSOperation_should_be_finished_if_called_start() {
        let operation: SimpleOperation = SimpleOperation()

        operation.start()

        XCTAssert(operation.finished)
    }
}

// SimpleOperation specific behavior: finish with result
extension SimpleOperationTests {
    func test_finish_with_result_should_finish_operation() {
        let operation: SimpleOperation = SimpleOperation()

        operation.finishWithResult(NSNull())

        XCTAssert(operation.finished)
    }

    func test_finish_with_result_should_finish_operation_with_given_result() {
        let operation: SimpleOperation = SimpleOperation()

        operation.finishWithResult(NSNull())

        if let result = operation.result {
            switch result {
                case .Result(let result):
                    XCTAssert(result as! NSObject == NSNull())

                case .Error:
                    XCTAssert(false)
                }
        } else {
            XCTAssert(false)
        }
    }
}

// SimpleOperation specific behavior: reject with error
extension SimpleOperationTests {
    func test_reject_with_error_should_finish_operation() {
        let operation: SimpleOperation = SimpleOperation()

        operation.rejectWithError(NSNull())

        XCTAssert(operation.finished)
    }

    func test_reject_with_error_should_finish_operation_with_given_error() {
        let operation: SimpleOperation = SimpleOperation()

        operation.rejectWithError(NSNull())

        if let result = operation.result {
            switch result {
                case .Result(_):
                    XCTAssert(false)

                case .Error(let error):
                    XCTAssert(error as! NSObject == NSNull())
                }
        } else {
            XCTAssert(false)
        }
    }
}
