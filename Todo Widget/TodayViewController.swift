//
//  TodayViewController.swift
//  Todo Widget
//
//  Created by Haspaker on 01/07/15.
//  Copyright (c) 2015 Haspaker. All rights reserved.
//

import Cocoa
import Foundation
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding, NCWidgetListViewDelegate, NCWidgetSearchViewDelegate {

    @IBOutlet var listViewController: NCWidgetListViewController!
    
    var editViewController: EditViewController?
    var settingsViewController: SettingsViewController?
    var menuItemViewController: MenuItemViewController?
    
    let MenuItemID: String = "LISTMENU"
    
    var settings: [String: Int] = ["sortTasks": 1, "removeCompleted": 0, "taskLimit": 9]

    override var nibName: String? {
        return "TodayViewController"
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initSettings()
        
        initListViewControllerContents()

        // Customize widget area style options
        listViewController.delegate = self
        listViewController.hasDividerLines = true
        listViewController.showsAddButtonWhenEditing = false
        listViewController.minimumVisibleRowCount = self.settings["taskLimit"]! + 1
    
        self.editViewController = EditViewController()
        self.editViewController!.mainViewController = self
        
        self.settingsViewController = SettingsViewController()
        self.settingsViewController!.mainViewController = self
        
    }
    
    func initSettings() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let sortTasksSetting = defaults.integerForKey("sortTasks") as Int? {
            self.settings["sortTasks"] = sortTasksSetting
        }
        
        if let sortTasksSetting = defaults.integerForKey("removeCompleted") as Int? {
            self.settings["removeCompleted"] = sortTasksSetting
        }
        
        if let taskLimit = defaults.integerForKey("taskLimit") as Int? {
            self.settings["taskLimit"] = taskLimit
        }
        
    }
    
    func initListViewControllerContents() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        self.listViewController.contents = []
        
        if let todoItemsAsDicts = defaults.arrayForKey("todoList") {
            
            for todoDict in todoItemsAsDicts {
                var todoItem = TodoItem( fromDict: todoDict as! [String: String] )
                self.listViewController?.contents?.append( todoItem )
            }
            
        } else {
            
            self.listViewController.contents = []
            addMenuItemOnTop()
            addNewTodoItem( "Todo - Add some new task" )
            
        }
    }
    
    func addMenuItemOnTop() {
        self.listViewController.contents.insert( TodoItem( fromDict: [
            "label": "Menu",
            "completed": "0",
            "id": self.MenuItemID,
            ]), atIndex: 0)
    }
    
    func saveSettings() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(self.settings["taskLimit"]!, forKey: "taskLimit")
        defaults.setInteger(self.settings["sortTasks"]!, forKey: "sortTasks")
        defaults.setInteger(self.settings["removeCompleted"]!, forKey: "removeCompleted")
        
    }
    
    func settingsDidUpdate() {
        
        listViewController.minimumVisibleRowCount = self.settings["taskLimit"]! + 1
        
        if self.settings["removeCompleted"]! == 1 {
            for todoItem in getCompletedItems() { removeTodoItem(todoItem.id) }
        }
        
        todoListDidUpdate()
        saveSettings()
        
    }
    
    func saveTodoList() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var todoItemsAsDicts = listViewController.contents.map({
            ($0 as! TodoItem).asDict()
        })
        defaults.setObject( todoItemsAsDicts, forKey: "todoList")
    }
    
    func getCompletedItems() -> [TodoItem] {
        return listViewController.contents.map({
                $0 as! TodoItem
            }).filter({
                $0.completed
            })
    }
    
    func getOpenItems() -> [TodoItem] {
        return listViewController.contents.map({
            $0 as! TodoItem
        }).filter({
            !$0.completed
        })
    }
    
    func todoListDidUpdate() {
        if self.settings["sortTasks"]! == 1 {
            listViewController.contents = getOpenItems() + getCompletedItems()
        }
        self.saveTodoList()
    }
    
    func getTodoItem(id: String) -> TodoItem? {
        for todoItem in listViewController.contents {
            if (todoItem as! TodoItem).id == id {
                return todoItem as? TodoItem
            }
        }
        return nil
    }
    
    func addNewTodoItem(label: String, completed: Bool = false ) {
        
        var index: Int = 1 // At 1 (not 0). So they do not appear above the menu item
        
        self.listViewController.contents.insert(
            TodoItem( label: label, completed: completed),
            atIndex: index
        )
        
        self.todoListDidUpdate()
    }
    
    func removeTodoItem(id: String) {
        self.getTodoItem(id)?.viewController?.view.hidden = true
        listViewController.contents = listViewController.contents.filter({
            ($0 as! TodoItem).id != id
        })
        
        self.todoListDidUpdate()
    }
    
    func completeItem(id: String) {
        var todo: TodoItem! = self.getTodoItem( id )
        if self.settings["removeCompleted"] == 1 {
            self.removeTodoItem( id )
        } else {
            todo.completed = true
        }
        
        self.todoListDidUpdate()
    }

    func reopenItem(id: String) {
        var todo: TodoItem! = self.getTodoItem(id)
        todo.completed = false
        self.todoListDidUpdate()
    }
    
    func toggleItem(id:String) {
        var todo: TodoItem! = self.getTodoItem(id)
        if todo.completed == false { self.completeItem(id) }
        else if todo.completed == true { self.reopenItem(id) }
    }

    override func dismissViewController(viewController: NSViewController) {
        super.dismissViewController(viewController)
    }

    // MARK: - NCWidgetProviding

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Refresh the widget's contents in preparation for a snapshot.
        // Call the completion handler block after the widget's contents have been
        // refreshed. Pass NCUpdateResultNoData to indicate that nothing has changed
        // or NCUpdateResultNewData to indicate that there is new data since the
        // last invocation of this method.
        completionHandler(.NewData)
    }

    func widgetMarginInsetsForProposedMarginInsets(var defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
        // Override the left margin so that the list view is flush with the edge.
        defaultMarginInset.left = 5
        return defaultMarginInset
    }

    var widgetAllowsEditing: Bool {
        // Return true to indicate that the widget supports editing of content and
        // that the list view should be allowed to enter an edit mode.
        return false
    }

    func widgetDidBeginEditing() {
        self.listViewController.editing = true
    }

    func widgetDidEndEditing() {
        self.listViewController.editing = false
    }

    // MARK: - NCWidgetListViewDelegate

    func widgetList(list: NCWidgetListViewController!, viewControllerForRow row: Int) -> NSViewController! {
        // Return a new view controller subclass for displaying an item of widget
        // content. The NCWidgetListViewController will set the representedObject
        // of this view controller to one of the objects in its contents array.
        var todoItem = listViewController.contents[row] as! TodoItem
        if todoItem.id == self.MenuItemID {
            var menuItemViewC: MenuItemViewController = MenuItemViewController()
            self.menuItemViewController = menuItemViewC
            menuItemViewC.mainViewController = self
            return menuItemViewC
        } else {
            var todoItemViewC: TodoItemViewController = TodoItemViewController()
            todoItem.viewController = todoItemViewC
            todoItemViewC.mainViewController = self
            return todoItemViewC
        }
    }

    func widgetListPerformAddAction(list: NCWidgetListViewController!) {
        // The user has clicked the add button in the list view.
        self.presentViewControllerInWidget(self.editViewController)
    }

    func widgetList(list: NCWidgetListViewController!, shouldReorderRow row: Int) -> Bool {
        // Return true to allow the item to be reordered in the list by the user.
        var todoItem = listViewController.contents[row] as! TodoItem
        
        if todoItem.id == self.MenuItemID { return false }
        
        return true
    }

    func widgetList(list: NCWidgetListViewController!, didReorderRow row: Int, toRow newIndex: Int) {
        self.todoListDidUpdate()
    }

    func widgetList(list: NCWidgetListViewController!, shouldRemoveRow row: Int) -> Bool {
        // Return true to allow the item to be removed from the list by the user.
        return false
    }

    func widgetList(list: NCWidgetListViewController!, didRemoveRow row: Int) {
        // The user has removed an item from the list.
    }

    // MARK: - NCWidgetSearchViewDelegate

    func widgetSearch(searchController: NCWidgetSearchViewController!, searchForTerm searchTerm: String!, maxResults max: Int) {
        // The user has entered a search term. Set the controller's searchResults property to the matching items.
        searchController.searchResults = []
    }

    func widgetSearchTermCleared(searchController: NCWidgetSearchViewController!) {
        // The user has cleared the search field. Remove the search results.
        searchController.searchResults = nil
    }

    func widgetSearch(searchController: NCWidgetSearchViewController!, resultSelected object: AnyObject!) {
        // The user has selected a search result from the list.
    }

}
