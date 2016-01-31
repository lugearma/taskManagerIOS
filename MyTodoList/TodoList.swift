//
//  TodoList.swift
//  MyTodoList
//
//  Created by Luis Arias on 26/01/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit

class TodoList: NSObject {
    
    override init() {
        super.init()
        loadItems()
    }
    
    var items: [String] = []
    private var fileURL: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        let documentsDirectoryURLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        
        let documentDirectoryURL = documentsDirectoryURLs.first!
        //print("El path del directory es: \(documentDirectoryURL)")
        return documentDirectoryURL.URLByAppendingPathComponent("todolist.items")
    }()
    
    func addItem(item: String){
        items.append(item)
        saveItem()
    }
    
    func saveItem(){
        let itemsArray = items as NSArray
        if itemsArray.writeToURL(self.fileURL, atomically: true){
            print("se guardo")
        }else{
            print("no se guardo")
        }
    }
    
    func loadItems(){
        if let itemsArray = NSArray(contentsOfURL: self.fileURL) as? [String]{
            self.items = itemsArray
        }
        
    }
    
    func getItem(index: Int) -> String{
        return items[index]
    }
    
    
}


extension TodoList: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let item: String = items[indexPath.row]
        
        cell.textLabel!.text = item
        
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














