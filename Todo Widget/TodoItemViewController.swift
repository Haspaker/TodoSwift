//
//  ListRowViewController.swift
//  Todo Widget
//
//  Created by Haspaker on 01/07/15.
//  Copyright (c) 2015 Haspaker. All rights reserved.
//

import Cocoa
import Foundation
import NotificationCenter

class TodoItemViewController: NSViewController {
    
    
    @IBOutlet var todoBox: NSButton?
    @IBOutlet var removeButton: NSButton?
    
    var mainViewController: TodayViewController?
    
    var todoItem: TodoItem?

    override var nibName: String? {
        return "TodoItemViewController"
    }

    override func loadView() {
        
        super.loadView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.todoItem = self.representedObject as? TodoItem
        var completed: Bool = (self.representedObject as! TodoItem).completed
        todoBox!.state = Int(completed)
        todoBox!.target = self
        todoBox!.action = "selected:"
        removeButton!.state = Int(completed)
        removeButton!.target = self
        removeButton!.action = "remove:"
        self.styleLabel()
        
    }
    
    func styleLabel() {
        var ats: NSMutableAttributedString = todoBox!.attributedTitle.mutableCopy() as! NSMutableAttributedString
        var fullRange: NSRange = NSMakeRange(0, ats.length)
        if(todoBox!.state == 1) {
            ats.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: fullRange)
            ats.addAttribute(NSForegroundColorAttributeName, value: NSColor.darkGrayColor(), range: fullRange)
        } else {
            ats.removeAttribute(NSStrikethroughStyleAttributeName, range: NSMakeRange(0, ats.length))
            ats.removeAttribute(NSForegroundColorAttributeName, range: NSMakeRange(0, ats.length))
        }
        todoBox!.attributedTitle = ats
    }
    
    func selected(_:AnyObject?) {
        self.styleLabel()
        self.view.display()
        self.mainViewController?.toggleItem(self.todoItem!.id)
    }

    func remove(_:AnyObject?) {
        self.view.hidden = true
        mainViewController?.removeTodoItem( self.todoItem!.id )
    }
    
}

