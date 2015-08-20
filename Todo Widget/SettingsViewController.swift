//
//  SettingsViewController.swift
//  Todo Swift
//
//  Created by Haspaker on 02/07/15.
//  Copyright (c) 2015 Haspaker. All rights reserved.
//

import Foundation
import Cocoa
import NotificationCenter

class SettingsViewController: NCWidgetSearchViewController {
    
    var mainViewController: TodayViewController?
    
    @IBOutlet var sortCheckbox: NSButton?
    @IBOutlet var removeCompletedCheckbox: NSButton?
    @IBOutlet var limitStepper: NSStepper?
    @IBOutlet var limitLabel: NSTextField?
    @IBOutlet var doneButton: NSButton?

    
    override var nibName: String? {
        return "SettingsViewController"
    }
    
    override func viewWillAppear() {
        
        doneButton!.target = self
        doneButton!.action = "done:"
        
        sortCheckbox!.target = self
        sortCheckbox!.action = "updateSettings:"
        
        limitStepper!.minValue = 2.0
        limitStepper!.target = self
        limitStepper!.integerValue = self.mainViewController!.settings["taskLimit"]!
        limitStepper!.action = "updateSettings:"
        updateStepperLabel()
        
        removeCompletedCheckbox!.target = self
        removeCompletedCheckbox!.action = "updateSettings:"
        
        removeCompletedCheckbox!.state = mainViewController!.settings["removeCompleted"]!
        sortCheckbox!.state = mainViewController!.settings["sortTasks"]!
    }
    
    func updateStepperLabel() {
        limitLabel!.stringValue = "Show at most \( limitStepper!.integerValue ) tasks at once"
    }
    
    func updateSettings(button:NSButton?) {
        updateStepperLabel()
        mainViewController?.settings["taskLimit"] = limitStepper!.integerValue
        mainViewController?.settings["sortTasks"] = sortCheckbox!.state
        mainViewController?.settings["removeCompleted"] = removeCompletedCheckbox!.state
        mainViewController?.settingsDidUpdate()
    }
    
    func done(_:AnyObject?) {
        mainViewController?.listViewController.dismissViewController( self )
    }
    
}