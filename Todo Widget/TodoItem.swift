//
//  TodoItem.swift
//  Todo Swift
//
//  Created by Haspaker on 18/08/15.
//  Copyright (c) 2015 Haspaker. All rights reserved.
//

import Cocoa
import Foundation

class TodoItem: NSObject {
    
    var label: String = ""
    var completed: Bool = false
    var id: String = ""
    var viewController: TodoItemViewController?
    
    init(label: String, completed: Bool = false) {
        self.label = label
        self.completed = completed
        self.id = NSUUID().UUIDString
    }
    
    init( fromDict: [String: String] ) {
        self.label = fromDict["label"]!
        self.completed = fromDict["completed"] == "1" ? true : false
        self.id = fromDict["id"]!
    }
    
    func asDict() -> [String: String] {
        return [
            "label": label as String!,
            "completed": self.completed ? "1" : "0",
            "id": id as String!
        ]
    }
    
}
