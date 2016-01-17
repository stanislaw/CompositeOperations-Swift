//
//  Sequence_Tests.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 17/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import XCTest
@testable import CompositeOperations

class LinearSequence_Tests: XCTestCase {
    func test_should_finish() {
        let sequentialOperation = SequentialOperation(sequence: TestLinearSequence_ThreeOperationsFinishingWithNull())

        waitForCompletion({ (done) -> Void in
            sequentialOperation.completion = { (result) in
                done()
            }

            sequentialOperation.start()
        })

        XCTAssertTrue(sequentialOperation.finished)
    }

    func test_completion_should_have_array_with_NSNull() {
        let sequentialOperation = SequentialOperation(sequence: TestLinearSequence_ThreeOperationsFinishingWithNull())

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
