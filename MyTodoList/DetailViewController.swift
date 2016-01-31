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
    static let dateFormat: String = "dd/MM/yyyy HH:mm"
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let itemDescription = item {
            self.taskLabel.text = itemDescription
        }
        
        addGestureRecognizerLabel()
    }
    
    @IBAction func dateSelected(sender: UIDatePicker) {
//        print("Fecha seleccionada: ", "\(sender.date)")
        self.dateLabel.text = dateFormat(sender.date)
        self.datePicker.hidden = true
    }
    
    @IBAction func confirmTaskDate(sender: UIBarButtonItem) {
        if let dateString = self.dateLabel.text {
            if let date = parseDate(dateString){
                scheduleNotification(self.item!, date: date)
            }
        }
    }
    
    
    @IBAction func addImage(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func scheduleNotification(message: String, date: NSDate){
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertTitle = "Remember this task!!!🙀"
        localNotification.alertBody = self.item!
        localNotification.applicationIconBadgeNumber = 1
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func dateFormat(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = DetailViewController.dateFormat
        return formatter.stringFromDate(date)
    }
    
    func parseDate(date: String) -> NSDate? {
        let parser = NSDateFormatter()
        parser.dateFormat = DetailViewController.dateFormat
        return parser.dateFromString(date)
    }
    
    func addGestureRecognizerLabel(){
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.addTarget(self, action: "toggleDatePicker")
        self.dateLabel.addGestureRecognizer(gestureRecognizer)
        self.dateLabel.userInteractionEnabled = true
    }
    
    func toggleDatePicker(){
        self.datePicker.hidden = !self.datePicker.hidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
