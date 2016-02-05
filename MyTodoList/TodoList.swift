//
//  TodoList.swift
//  MyTodoList
//
//  Created by Luis Arias on 26/01/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit

class TodoList: NSObject {
    
    var items: [TodoItem] = []
    
    override init() {
        super.init()
        loadItems()
    }
    
    private var fileURL: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        let documentsDirectoryURLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        
        let documentDirectoryURL = documentsDirectoryURLs.first!
        //print("El path del directory es: \(documentDirectoryURL)")
        return documentDirectoryURL.URLByAppendingPathComponent("todolist.plist")
    }()
    
    func addItem(item: TodoItem){
        items.append(item)
        saveItem()
    }
    
    func saveItem(){
        let itemsArray = items as NSArray
        if NSKeyedArchiver.archiveRootObject(itemsArray, toFile: self.fileURL.path!){
            print("Saved")
        } else {
            print("Error to save")
        }
    }
    
    func loadItems(){
        if let itemsArray = NSKeyedUnarchiver.unarchiveObjectWithFile(self.fileURL.path!){
            self.items = itemsArray as! [TodoItem]
        }
        
    }
    
    func getItem(index: Int) -> TodoItem{
        return items[index]
    }
}


extension TodoList: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel!.text = item.todo
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        items.removeAtIndex(indexPath.row)
        saveItem()
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        tableView.endUpdates()
    }
        
}














