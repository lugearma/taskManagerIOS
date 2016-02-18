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
        addGestureRecognizerImage()
    }
    
    func addGestureRecognizerImage(){
        let gr = UITapGestureRecognizer(target: self, action: "rotateImage")
//        let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 2
        gr.numberOfTouchesRequired = 1
//        gr.addTarget(imageView, action: "rotateImage")
        self.imageView.addGestureRecognizer(gr)
        self.imageView.userInteractionEnabled = true
    }
    
    func rotateImage(){
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.toValue = M_PI * 2.0
        animation.duration = 1
        self.imageView.layer.addAnimation(animation, forKey: "rotateAnimation")
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
                API.save(self.item!, todo: self.todoList!, responseBlock: {
                    (error) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let _ = error{
                            self.showError()
                        }else{
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                })
            }
        }
    }
    
    func showError() {
        let alert = UIAlertController(title: "Upss", message: "No pudimos guardar tus cambias, revisa tu conexión a internet", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default){
            _ in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(action)
        alert.presentViewController(alert, animated: true, completion: nil)
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
        if self.datePicker.hidden {
            self.fadeInDatePicker()
        }else{
            self.fadeOutDatePicker()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Animations
    func fadeInDatePicker() {
        self.datePicker.alpha = 0
        self.datePicker.hidden = false
        UIView.animateWithDuration(1){ () -> Void in
            self.datePicker.alpha = 1
            self.imageView.alpha = 0
        }
    }
    
    func fadeOutDatePicker() {
        self.datePicker.alpha = 1
        self.datePicker.hidden = false
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.datePicker.alpha = 0
            self.imageView.alpha = 1
            }){ (completed) -> Void in
                if completed {
                    self.datePicker.hidden = true
                }
        }
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
