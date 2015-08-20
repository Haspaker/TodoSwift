//
//  ListMenuViewController.swift
//  Todo Swift
//
//  Created by Haspaker on 02/07/15.
//  Copyright (c) 2015 Haspaker. All rights reserved.
//

import Foundation
import Cocoa
import NotificationCenter

class MenuItemViewController: NSViewController {
    
    var mainViewController: TodayViewController?
    
    @IBOutlet var addTaskButton: NSButton?
    @IBOutlet var settingsButton: NSButton?
    @IBOutlet var reorderButton: NSButton?
    
    var addTaskButtonTitle: String = "+ Add Task"
    var reorderRowsMessage: String = "Press enter when done"
    
    override var nibName: String? {
        return "MenuItemViewController"
    }
    
    override func viewDidLoad() {
        
        addTaskButton!.target = self
        addTaskButton!.action = "addTask:"
        
        settingsButton!.target = self
        settingsButton!.action = "showSettings:"
        
        reorderButton!.target = self
        reorderButton!.action = "reorderTodoItems:"
        
    }
    
    func addTask(_:AnyObject?) {
        mainViewController?.widgetListPerformAddAction(
            mainViewController!.listViewController
        )
    }
    
    func showSettings(_:AnyObject?) {
        mainViewController!.presentViewControllerInWidget( mainViewController?.settingsViewController)
    }
    
    func reorderTodoItems(_:AnyObject?) {
        
        if mainViewController?.listViewController?.editing == true {
            reorderButton!.keyEquivalent = ""
            mainViewController?.widgetDidEndEditing()
            addTaskButton!.title = addTaskButtonTitle
        } else {
            reorderButton!.keyEquivalent = "\r"
            mainViewController?.widgetDidBeginEditing()
            addTaskButton!.title = reorderRowsMessage
        }
        
    }
    
    
}