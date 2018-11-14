//
//  ViewController.swift
//  OSLockCompareDemo
//
//  Created by Kobe on 2018/11/7.
//  Copyright © 2018 Kobe. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var sttf: NSTextField!
    @IBOutlet weak var mttf: NSTextField!
    
    @IBOutlet weak var stcf: NSTextField!
    @IBOutlet weak var mtcf: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func startSingleThreadTest(_ sender: NSButton) {
        
        let testCount = sttf.integerValue
        sender.isEnabled = false
        
        if OSLockCompare.startThreadCompare(testCount) {
            
            sender.isEnabled = true 
        }
    }
    
    
    @IBAction func startMultiThreadTest(_ sender: NSButton) {
        
        let testCount = mttf.integerValue
        let threadCnt = mtcf.integerValue
        sender.isEnabled = false
        
        OSLockCompare.startMultiThreadCompare(testCount,
                                              threadCount: threadCnt) { (value) in
                                                if value {
                                                    
                                                    DispatchQueue.main.async {
                                                        
                                                        sender.isEnabled = true
                                                    }
                                                }
        }
    }
}

