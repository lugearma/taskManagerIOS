//
//  API.swift
//  MyTodoList
//
//  Created by Luis Arias on 11/02/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit

class API {
    
    class func uniqueUsername() -> String{
        if let username = NSUserDefaults().objectForKey("username") as? String{
            return username
        } else {
            let newUsername = generateUsername()
            NSUserDefaults.standardUserDefaults().setObject(newUsername, forKey: "username")
            return newUsername
        }
    }
    
    class func generateUsername() -> String {
        let uuid = NSUUID().UUIDString
        return (uuid as NSString).substringToIndex(5)
    }
    
    class func save(item: TodoItem, todo: TodoList, responseBlock: (NSError?) -> Void){
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "https://pendientesapp.herokuapp.com/todo")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        var body: Dictionary<String, AnyObject> = ["message": item.todo!, "user": self.uniqueUsername()]
        if let date = item.dueDate {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy: HH:mm"
            body["dueDate"] = formatter.stringFromDate(date)
        }
        if let identifier = item.id {
            body["id"] = NSNumber(longLong: identifier)
        }
        
        let data = try! NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
        
        request.HTTPBody = data
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if let err = error{
                responseBlock(err)
            } else {
                if let d = data{
                    let result = try! NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments)
                    print("response", result);
                    if let id = result["id"] as? Int64{
                        item.id = id
                        todo.saveItem()
                    }
                }
            }
        }
    task.resume()
    }

}












