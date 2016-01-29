//
//  DetailViewController.swift
//  MyTodoList
//
//  Created by Luis Arias on 28/01/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var item: String?
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let itemDescription = item {
            self.taskLabel.text = itemDescription
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
