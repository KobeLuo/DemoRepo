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
        
        let testCount = Int(sttf.stringValue)
        sender.isEnabled = false
        
        if OSSingleThreadCompare.startThreadCompare(testCount!) {
            
            sender.isEnabled = true
        }
    }
    
    
    @IBAction func startMultiThreadTest(_ sender: Any) {
        
        
    }
}

