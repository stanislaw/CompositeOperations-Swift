//
//  Unit_SequentialOperation_Tests.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import XCTest
@testable import CompositeOperations

class SequentialOperation_InitialState_Test: XCTestCase {
    let sequentialOperation = SequentialOperation(sequence: TestSequence_Null())

    func test_should_be_ready() {
        XCTAssert(sequentialOperation.ready)
    }

    func test_should_not_be_executing() {
        XCTAssertFalse(sequentialOperation.executing)
    }

    func test_should_not_be_finished() {
        XCTAssertFalse(sequentialOperation.finished)
    }
}

class SequentialOperation_NullSequence_Test: XCTestCase {
    let sequentialOperation = SequentialOperation(sequence: TestSequence_Null())

    func test_should_finish() {
        sequentialOperation.start()

        XCTAssertTrue(sequentialOperation.finished)
    }
}

class SequentialOperation_Sequence_OneOperation_Test: XCTestCase {
    func test_should_finish() {
        let sequentialOperation = SequentialOperation(sequence: TestSequence_OneOperationFinishingWithNull())

        waitForCompletion({ (done) -> Void in
            sequentialOperation.completion = { (result) in
                done()
            }

            sequentialOperation.start()
        })

        XCTAssertTrue(sequentialOperation.finished)
    }

    func test_completion_should_have_array_with_NSNull() {
        let sequentialOperation = SequentialOperation(sequence: TestSequence_OneOperationFinishingWithNull())

        var expectedResult: CompositeOperationResult? = nil

        waitForCompletion({ (done) -> Void in
            sequentialOperation.completion = { (result) in
                expectedResult = result

                done()
            }

            sequentialOperation.start()
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

            default:
                XCTFail()
        }
    }
}

class SequentialOperation_Sequence_ManyOperations_Success_Test: XCTestCase {
    func test_should_finish() {
        let sequentialOperation = SequentialOperation(sequence: TestSequence_ThreeOperationsFinishingWithNull())

        waitForCompletion({ (done) -> Void in
            sequentialOperation.completion = { (result) in
                done()
            }

            sequentialOperation.start()
        })

        XCTAssertTrue(sequentialOperation.finished)
    }

    func test_completion_should_have_array_with_NSNull() {
        let sequentialOperation = SequentialOperation(sequence: TestSequence_ThreeOperationsFinishingWithNull())

        var expectedResult: CompositeOperationResult? = nil

        waitForCompletion({ (done) -> Void in
            sequentialOperation.completion = { (result) in
                expectedResult = result

                done()
            }

            sequentialOperation.start()
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

class SequentialOperation_Sequence_ThirdOperationFinishesWithFailure_Test: XCTestCase {
    func test_should_finish() {
        let sequentialOperation = SequentialOperation(sequence: TestSequence_ThreeOperations_ThirdFinishesWithError_Null())

        waitForCompletion({ (done) -> Void in
            sequentialOperation.completion = { (result) in
                done()
            }

            sequentialOperation.start()
        })

        XCTAssertTrue(sequentialOperation.finished)
    }

    func test_completion_should_have_array_with_NSNull() {
        let sequentialOperation = SequentialOperation(sequence: TestSequence_ThreeOperations_ThirdFinishesWithError_Null())

        var expectedResult: CompositeOperationResult? = nil

        waitForCompletion({ (done) -> Void in
            sequentialOperation.completion = { (result) in
                expectedResult = result

                done()
            }

            sequentialOperation.start()
        })

        switch expectedResult! {
        case .Errors(let errors):
            XCTAssertEqual(errors.count, 3)

            let firstError = errors.first!
            XCTAssertNil(firstError)

            let thirdError = errors.last!
            switch thirdError! {
                case .Error(let error):
                    XCTAssert(error as! NSNull == NSNull())
                default:
                    XCTFail()
            }

        case .Results(_):
            XCTFail()
        default:
            XCTFail()
        }
    }
}
