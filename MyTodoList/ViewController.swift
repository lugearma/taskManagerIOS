//
//  ViewController.swift
//  MyTodoList
//
//  Created by Luis Arias on 23/01/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let todoList: TodoList = TodoList()
    
    @IBAction func addButtonPressed(sender: UIButton){
        if let item = textField.text{
            print("Elemento del textInput: ", "\(item)")
            todoList.addItem(item)
            tableView.reloadData()
        }else{
            print("no hay valor")
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = todoList
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

