//
//  ViewController.swift
//  MyTodoList
//
//  Created by Luis Arias on 23/01/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    static let MAX_TEXT_SIZE = 50
    
    let todoList: TodoList = TodoList()
    
    @IBAction func addButtonPressed(sender: UIButton){
        if let item = textField.text{
            print("Elemento del textInput: ", "\(item)")
            todoList.addItem(item)
            tableView.reloadData()
        }else{
            print("no hay valor")
        }
        textField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = todoList
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Delegate tableView methods
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textField.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showItem", sender: self)
    }
    
    //MARK: Delegate TextField methods
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let taskString = textField.text as? NSString{
            let updateString = taskString.stringByReplacingCharactersInRange(range, withString: string)
            print("Esta cadena pone algo: ", updateString)
            return updateString.characters.count <= ViewController.MAX_TEXT_SIZE
        } else {
            return true
        }
    }

}

