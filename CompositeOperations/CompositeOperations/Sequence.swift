//
//  Sequence.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation

protocol Sequence {
    func nextOperation(previousOperation: Operation?) -> Operation?
}
