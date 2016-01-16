//
//  TestHelpers.swift
//  CompositeOperations
//
//  Created by Stanislaw Pankevich on 16/01/16.
//  Copyright © 2016 Stanislaw Pankevich. All rights reserved.
//

import Foundation

func waitForCompletion(completion: (completion: () -> Void) -> Void) {
    var done = false

    let doneBlock = {
        done = true
    }

    completion(completion: doneBlock)

    while done == false {
        runLoop()
    }
}

func runLoop(interval: CFTimeInterval? = CFTimeInterval(0.05)) {
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, interval!, true);
}
