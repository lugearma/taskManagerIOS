//
//  TodoList.swift
//  MyTodoList
//
//  Created by Luis Arias on 26/01/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit

class TodoList: NSObject {
    var items: [String] = []
    
    func addItem(item: String){
        items.append(item)
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
}