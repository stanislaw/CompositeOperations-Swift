//
//  AbstractOperation.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation

public class AbstractOperation : NSOperation, Operation {
    internal enum OperationState {
        case Ready
        case Executing
        case Finished(OperationResult)

        func isValidTransition(to: OperationState) -> Bool {
            switch self {
                case .Ready:
                    switch to {
                        case .Executing:
                            return true
                        case .Finished(_):
                            return true
                        default:
                            return false
                    }

                case .Executing:
                    switch to {
                        case .Finished(_):
                            return true
                        default:
                            return false
                    }


                default:
                    return false
            }
        }

        func toString() -> String {
            switch self {
                case Ready:
                    return "isReady"
                case Executing:
                    return "isExecuting"
                case Finished(_):
                    return "isFinished"
            }
        }
    }

    private var _state: OperationState = .Ready

    // TODO: add lock to make @state thread-safe
    internal var state: OperationState {
        get {
            return _state
        }

        set {
            guard _state.isValidTransition(newValue) else {
                // TODO: throw here

                print("Invalid transition from \(_state) to \(newValue)")

                return
            }

            let oldStateString = _state.toString()
            let newStateString = newValue.toString()

            willChangeValueForKey(newStateString)
            willChangeValueForKey(oldStateString)
            _state = newValue
            didChangeValueForKey(oldStateString)
            didChangeValueForKey(newStateString)
        }
    }

    final override public var ready: Bool {
        switch state {
        case .Ready:
            return true
        default:
            return false
        }
    }

    final override public var executing: Bool {
        switch state {
        case .Executing:
            return true
        default:
            return false
        }
    }

    final override public var finished: Bool {
        switch state {
        case .Finished(_):
            return true
        default:
            return false
        }
    }

    final public var result: OperationResult? {
        switch state {
        case .Finished(let result):
            return result
        default:
            return nil
        }
    }

    final override public func start() {
        if ready {
            state = .Executing;

            if cancelled {
                state = .Finished(.Cancelled)
            } else {
                self.main()
            }
        }
    }
}
