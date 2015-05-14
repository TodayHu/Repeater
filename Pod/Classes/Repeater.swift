//
//  Repeater.swift
//  Repeater
//
//  Created by Konstantin Gerasimov on  7/9/14.
//
//

import Foundation

public class Repeater {
    
    var repeatTimeoutMilliseconds: Int = 1000
    var repeatAccuracyMilliseconds: Int = 1
    var isRepeating = false
    var timer: dispatch_source_t?
    
    deinit {
        stop()
    }
    
    
    init() {
    }
    
    public convenience init(timeoutMs: Int, accuracyMs: Int) {
        self.init()
        repeatTimeoutMilliseconds = timeoutMs
        repeatAccuracyMilliseconds = accuracyMs
    }
    
    
    public func repeat(repeat: (()->())) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        repeatInQueue(queue, repeat: repeat)
    }
    
    
    public func repeatInQueue(queue: dispatch_queue_t, repeat: (() -> ())) {
        repeatInQueue(queue, timeoutMs: repeatTimeoutMilliseconds, accuracyMs: repeatAccuracyMilliseconds, repeat: repeat)
    }
    
    public func repeatWithTimeout(timeoutSec: Double, repeat: (() -> ())) {
        repeatInQueue(dispatch_get_main_queue(), timeoutMs: Int(timeoutSec * 1000), accuracyMs: Int(timeoutSec), repeat: repeat)
    }
    
    public func repeatWithTimeout(timeoutSec: Int, repeat: (() -> ())) {
        repeatInQueue(dispatch_get_main_queue(), timeoutMs: timeoutSec * 1000, accuracyMs: timeoutSec, repeat: repeat)
    }
    
    public func repeatInBgWithTimeout(timeoutSec: Double, repeat: (() -> ())) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        repeatInQueue(queue, timeoutMs: Int(timeoutSec * 1000), accuracyMs: Int(timeoutSec), repeat: repeat)
    }
    
    public func repeatInQueue(queue: dispatch_queue_t, var timeoutMs: Int, var accuracyMs: Int, repeat: (() -> ())) {
        
        stop()
        isRepeating = true
        
        if timeoutMs < 1 {
            timeoutMs = 1
        }
        if accuracyMs < 1 {
            accuracyMs = 1
        }
        
        let interval: UInt64 = NSEC_PER_MSEC * UInt64(timeoutMs)
        let leeway: UInt64 = NSEC_PER_MSEC * UInt64(accuracyMs)
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        if let existedTimer = timer {
            dispatch_source_set_timer(existedTimer, dispatch_walltime(nil, 0), interval, leeway)
            dispatch_source_set_event_handler(existedTimer) {
                repeat()
            }
            dispatch_resume(existedTimer)
        }
    }
    
    public func stop() {
        if let existedTimer = timer {
            dispatch_source_cancel(existedTimer);
        }
        isRepeating = false
    }
}

