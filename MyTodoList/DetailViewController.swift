//
//  DetailViewController.swift
//  MyTodoList
//
//  Created by Luis Arias on 28/01/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var item: TodoItem?
    var todoList: TodoList?
    static let dateFormat: String = "dd/MM/yyyy HH:mm"
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showItem()
        addGestureRecognizerLabel()

    }
    
    func showItem(){
        if let itemDescription = item {
            self.taskLabel.text = itemDescription.todo
        }
        if let date = item?.dueDate{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            self.dateLabel.text = formatter.stringFromDate(date)
        }
        if let image = item?.image{
            self.imageView.image = image
        }
    }
    
    @IBAction func dateSelected(sender: UIDatePicker) {
//        print("Fecha seleccionada: ", "\(sender.date)")
        self.dateLabel.text = dateFormat(sender.date)
//        self.datePicker.hidden = true
        toggleDatePicker()
    }
    
    @IBAction func confirmTaskDate(sender: UIBarButtonItem) {
        if let dateString = self.dateLabel.text {
            if let date = parseDate(dateString){
                self.item?.dueDate = date
                self.todoList?.saveItem()
                scheduleNotification(self.item!.todo!, date: date)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    
    @IBAction func addImage(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func scheduleNotification(message: String, date: NSDate){
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertTitle = "Remember this task!!!🙀"
        localNotification.alertBody = self.item?.todo
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
        self.imageView.hidden = self.datePicker.hidden
        self.datePicker.hidden = !self.datePicker.hidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ImagePickerController methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.item?.image = image
            self.todoList?.saveItem()
            self.imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
