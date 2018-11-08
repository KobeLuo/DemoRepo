//
//  OSSingleThreadCompare.swift
//  OSLockCompareDemo
//
//  Created by Kobe on 2018/11/7.
//  Copyright © 2018 Kobe. All rights reserved.
//

import Cocoa

//lock type enum
public enum OSLockType: Int {
    case l_OSSpinLock       = 0
    case l_Semaphore        = 1
    case l_mutex            = 2
    case l_mutexRecurisive  = 3
    case l_NSCondition      = 4
    case l_NSConditionLock  = 5
    case l_NSLock           = 6
    case l_NSRecusiveLock   = 7
    case l_Synchronized     = 8
    case l_OSUnfairLock     = 9
}

class OSSingleThreadCompare {

    class func startThreadCompare(_ testTimes: Int) -> Bool {
        
        
        
        return true
    }
}
