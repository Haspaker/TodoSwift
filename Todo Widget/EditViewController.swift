//
//  ViewController.swift
//  Todo Swift
//
//  Created by Haspaker on 01/07/15.
//  Copyright (c) 2015 Haspaker. All rights reserved.
//

import Cocoa
import Foundation
import NotificationCenter

class EditViewController: NCWidgetSearchViewController {
    
    
    @IBOutlet var addButton: NSButton?
    @IBOutlet var cancelButton: NSButton?
    @IBOutlet var labelField: NSTextField?

    var mainViewController: TodayViewController?
    
    override var nibName: String? {
        return "EditViewController"
    }
    
    override func loadView() {
        
        super.loadView()
        
        
    }
    
    override func viewDidLoad() {
        
        addButton!.target = self
        addButton!.action = "addTodo:"
        
        cancelButton!.target = self
        cancelButton!.action = "done:"
        
        labelField!.target = self
        labelField!.action = "addTodo:"
        
    }
    
    override func viewWillAppear() {
        labelField!.stringValue = ""
        //labelField!.placeholderString = "..."
        self.view.window?.makeFirstResponder( labelField )
    }
    
    func addTodo(_:AnyObject?) {
        var label: String = labelField!.stringValue
        if label != "" {
            mainViewController?.addNewTodoItem( label )
        }
        self.done(self)
    }
    
    func done(_:AnyObject?) {
        mainViewController?.dismissViewController(self)
    }
    
}

