//
//  Unit_SequentialOperation_Tests.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import XCTest
@testable import CompositeOperations

class Unit_SequentialOperation_InitialState: XCTestCase {
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

class Unit_SequentialOperation_NullSequence: XCTestCase {
    let sequentialOperation = SequentialOperation(sequence: TestSequence_Null())

    func test_should_finish() {
        sequentialOperation.start()

        XCTAssertTrue(sequentialOperation.finished)
    }
}

class Unit_SequentialOperation_Sequence_OneOperation: XCTestCase {
    var sequentialOperation: SequentialOperation!

    override func setUp() {
        sequentialOperation = SequentialOperation(sequence: TestSequence_OneOperationFinishingWithNull())
    }

    func test_should_finish() {
        waitForCompletion({ (done) -> Void in
            self.sequentialOperation.completion = { (result) in
                done()
            }

            self.sequentialOperation.start()
        })

        XCTAssertTrue(sequentialOperation.finished)
    }

    func test_completion_should_have_array_with_NSNull() {
        var expectedResult: CompositeOperationResult? = nil

        waitForCompletion({ (done) -> Void in
            self.sequentialOperation.completion = { (result) in
                expectedResult = result

                done()
            }

            self.sequentialOperation.start()
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

class Unit_SequentialOperation_Sequence_ManyOperations: XCTestCase {
    var sequentialOperation: SequentialOperation!

    override func setUp() {
        sequentialOperation = SequentialOperation(sequence: TestSequence_ThreeOperationsFinishingWithNull())
    }

    func test_should_finish() {
        waitForCompletion({ (done) -> Void in
            self.sequentialOperation.completion = { (result) in
                done()
            }

            self.sequentialOperation.start()
        })

        XCTAssertTrue(sequentialOperation.finished)
    }

    func test_completion_should_have_array_with_NSNull() {
        var expectedResult: CompositeOperationResult? = nil

        waitForCompletion({ (done) -> Void in
            self.sequentialOperation.completion = { (result) in
                expectedResult = result

                done()
            }

            self.sequentialOperation.start()
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
