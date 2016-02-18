//
//  TodoItem.swift
//  MyTodoList
//
//  Created by Luis Arias on 04/02/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit

class TodoItem : NSObject, NSCoding{
    
    var todo: String?
    var dueDate: NSDate?
    var image: UIImage?
    
    var id: Int64?
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let message = aDecoder.decodeObjectForKey("item") as? String{
            self.todo = message
        }
        if let date = aDecoder.decodeObjectForKey("dueDate") as? NSDate{
            self.dueDate = date
        }
        if let img = aDecoder.decodeObjectForKey("image") as? UIImage{
            self.image = img
        }
        let identifier = aDecoder.decodeInt64ForKey("identifier")
        if identifier != 0 {
            self.id = identifier
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let message = self.todo {
            aCoder.encodeObject(message, forKey: "item")
        }
        if let date = self.dueDate{
            aCoder.encodeObject(date, forKey: "image")
        }
        if let _ = self.image {
            aCoder.encodeObject(image, forKey: "image")
        }
        if let identifier = self.id {
            aCoder.encodeInt64(identifier, forKey: "identifier")
        }
    }
}
