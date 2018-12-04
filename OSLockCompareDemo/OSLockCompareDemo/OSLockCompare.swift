//
//  OSLockCompare.swift
//  OSLockCompareDemo
//
//  Created by Kobe on 2018/11/7.
//  Copyright © 2018 Kobe. All rights reserved.
//

import Cocoa
import Foundation


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

class OSLockCompare {

    var repeatTimes = 1
    var treadCount = 1
    
    var timeCosts = [OSLockType : Double]()
    
    var splinLock = OS_SPINLOCK_INIT
    var unfair = os_unfair_lock()
    
    let sema: DispatchSemaphore = DispatchSemaphore.init(value: 1)
    
    var mutex = pthread_mutex_t()
    
    var rmutex = pthread_mutex_t()
    
    let condition = NSCondition.init()
    let clock = NSConditionLock.init()
    
    let lock = NSLock.init()
    let rlock = NSRecursiveLock.init()
    
    typealias invokeBlock = (Bool) -> Void
    var invoke: invokeBlock?
    var tcount = 1
    var rcount = 0
    
    var queues: [AnyObject]?
    
    init(testTimes tt: Int,_ tc: Int? = nil) {
        
        repeatTimes = tt
        if tc != nil { treadCount = tc! }
        let ctypes = lockTypes().count
        tcount = tt * treadCount * ctypes
        //initial mutex
        pthread_mutex_init(&mutex, nil)
        //initial recusive mutex
        var attr: pthread_mutexattr_t = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&rmutex, &attr)
        pthread_mutexattr_destroy(&attr)
        //initial time costs.
        for type in lockTypes() { timeCosts[type] = 0 }
    }
    
    private func lockTypes() -> [OSLockType] {
        
        return [
            OSLockType.l_OSSpinLock,
            OSLockType.l_Semaphore,
            OSLockType.l_mutex,
            OSLockType.l_NSLock,
            OSLockType.l_NSCondition,
            OSLockType.l_OSUnfairLock,
            OSLockType.l_NSRecusiveLock,
            OSLockType.l_mutexRecurisive,
            OSLockType.l_NSConditionLock
        ]
    }
    
    
    class func startThreadCompare(_ testTimes: Int) -> Bool {
        //initial class
        let compare = OSLockCompare.init(testTimes: testTimes)
        //test locks
        compare.testLocks()
        
        return true
    }
    
    class func startMultiThreadCompare(_ testTimes: Int, threadCount: Int, ci: @escaping invokeBlock) {
        
        let compare = OSLockCompare.init(testTimes: testTimes, threadCount)
        let labelbase = "com.compare.oslock"
        
        compare.invoke = ci
        
        var subQueues = [DispatchQueue]()
        
        for index in 1...threadCount {
            
            let label = labelbase + ".\(index)"
            let seriaQueue = DispatchQueue.init(label: label)
            
            seriaQueue.async { compare.testLocks() }
            
            subQueues.append(seriaQueue)
        }
        
        compare.queues = subQueues
    }
    
    private func testLocks() {
        
        testOSSpinlock()
        testSemaphore()
        testPthreadMutex()
        testPthreadMutexRecusive()
        testNSCondition()
        testNSConditionLock()
        testNSLock()
        testNSRecusiveLock()
        testOSUnfairLock()
    }

    private func recordTimeFor(type: OSLockType, time: Double) {
        
        if Thread.isMainThread == false {
            
            DispatchQueue.main.sync {
                self.recordTimeOnUniqueue(type: type, time: time)
            }
        }else {
            
            self.recordTimeOnUniqueue(type: type, time: time)
        }
    }
    
    private func recordTimeOnUniqueue(type:OSLockType, time: Double) {
        
        var currentValue = timeCosts[type]!
        currentValue += time
        timeCosts[type] = currentValue
        
        rcount = rcount + 1
        if rcount >= tcount {
            
            //print result
            self.outputResult()
            
            //invoke to observer
            if let ci = invoke { ci(true) }
        }
    }
    
    private func outputResult() {
        
        if self.treadCount > 1 {
            
            print("\nMulti thread time cost:")
        }else { print("\nSingle thread time cost:") }
        
        let scale:Double = 10000000
        
        print("OSSpinLock:               \(timeCosts[OSLockType.l_OSSpinLock]! * scale)")
        print("dispatch_semaphore:       \(timeCosts[OSLockType.l_Semaphore]! * scale)")
        print("pthread_mutex:            \(timeCosts[OSLockType.l_mutex]! * scale)")
        print("pthread_mutex(recursive): \(timeCosts[OSLockType.l_mutexRecurisive]! * scale)")
        print("NSCondition:              \(timeCosts[OSLockType.l_NSCondition]! * scale)")
        print("NSConditionLock:          \(timeCosts[OSLockType.l_NSConditionLock]! * scale)")
        print("NSLock:                   \(timeCosts[OSLockType.l_NSLock]! * scale)")
        print("NSRecursiveLock:          \(timeCosts[OSLockType.l_NSRecusiveLock]! * scale)")
        print("OSUnfairLock:             \(timeCosts[OSLockType.l_OSUnfairLock]! * scale)")
        
        print("\(Int(timeCosts[OSLockType.l_OSSpinLock]! * scale))")
        print("\(Int(timeCosts[OSLockType.l_Semaphore]! * scale))")
        print("\(Int(timeCosts[OSLockType.l_mutex]! * scale))")
        print("\(Int(timeCosts[OSLockType.l_mutexRecurisive]! * scale))")
        print("\(Int(timeCosts[OSLockType.l_NSCondition]! * scale))")
        print("\(Int(timeCosts[OSLockType.l_NSConditionLock]! * scale))")
        print("\(Int(timeCosts[OSLockType.l_NSLock]! * scale))")
        print("\(Int(timeCosts[OSLockType.l_NSRecusiveLock]! * scale))")
        print("\(Int(timeCosts[OSLockType.l_OSUnfairLock]! * scale))")
    }
    
    //mark: test locks
    private func testOSSpinlock() {
        
        for index in 1...repeatTimes {
            let start = CACurrentMediaTime()
            OSSpinLockLock(&splinLock)
            print("index:\(index) ")
            OSSpinLockUnlock(&splinLock)
            let end = CACurrentMediaTime()
            recordTimeFor(type: OSLockType.l_OSSpinLock, time: end - start)
        }
    }
    
    private func testSemaphore() {
        
        for index in 1...repeatTimes {
            
            let start = CACurrentMediaTime()
            
            sema.wait()
            //如果要去掉上下文，则注释该print
            print("index: \(index) ")
            sema.signal()
            
            let end = CACurrentMediaTime()
            self.recordTimeFor(type: OSLockType.l_Semaphore, time: end - start)
        }
    }
    
    private func testPthreadMutex() {
        
        for index in 1...repeatTimes {
            
            let start = CACurrentMediaTime()
            
            pthread_mutex_lock(&mutex)
            print("index: \(index) ")
            pthread_mutex_unlock(&mutex)
            
            let end = CACurrentMediaTime()
            self.recordTimeFor(type: OSLockType.l_mutex, time: end - start)
        }
    }
    
    private func testPthreadMutexRecusive() {
        
        for index in 1...repeatTimes {
            
            let start = CACurrentMediaTime()
            
            pthread_mutex_lock(&rmutex)
            print("index: \(index) ")
            pthread_mutex_unlock(&rmutex)
            
            let end = CACurrentMediaTime()
            self.recordTimeFor(type: OSLockType.l_mutexRecurisive, time: end - start)
        }
    }
    
    private func testNSCondition() {
        
        for index in 1...repeatTimes {
            
            let start = CACurrentMediaTime()
            
            condition.lock()
            print("index: \(index) ")
            condition.unlock()
            
            let end = CACurrentMediaTime()
            self.recordTimeFor(type: OSLockType.l_NSCondition, time: end - start)
        }
    }
    
    private func testNSConditionLock() {
        
        for index in 1...repeatTimes {
            
            let start = CACurrentMediaTime()
            
            clock.lock()
            print("index: \(index) ")
            clock.unlock()
            clock.try()
            let end = CACurrentMediaTime()
            recordTimeFor(type: OSLockType.l_NSConditionLock, time: end - start)
        }
    }
    
    private func testNSLock() {
        
        for index in 1...repeatTimes {
            
            let start = CACurrentMediaTime()
            
            lock.lock()
            print("index: \(index) ")
            lock.unlock()
            
            let end = CACurrentMediaTime()
            recordTimeFor(type: OSLockType.l_NSLock, time: end - start)
        }
    }
    
    private func testNSRecusiveLock() {
        
        for index in 1...repeatTimes {
            
            let start = CACurrentMediaTime()
            
            rlock.lock()
            print("index: \(index) ")
            rlock.unlock()
            
            let end = CACurrentMediaTime()
            self.recordTimeFor(type: OSLockType.l_NSRecusiveLock, time: end - start)
        }
    }
    
    private func testOSUnfairLock() {
        
        for index in 1...repeatTimes {
            
            let start = CACurrentMediaTime()
            
            os_unfair_lock_lock(&unfair)
            print("index: \(index) ")
            os_unfair_lock_unlock(&unfair)
            
            let end = CACurrentMediaTime()
            self.recordTimeFor(type: OSLockType.l_OSUnfairLock, time: end - start)
        }
    }
}
