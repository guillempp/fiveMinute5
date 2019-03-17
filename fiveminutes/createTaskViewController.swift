//
//  createTaskViewController.swift
//  fiveminutes
//
//  Created by Guillem Pérez on 10/29/17.
//  Copyright © 2017 Guillem Pérez. All rights reserved.
//

import UIKit
import Firebase
import NotificationCenter
import UserNotifications
import ChameleonFramework


//Default Keys
struct defaultsKeys {
    
    static var task = String()
    static var time = Date()
    static var timeExistsFirebase = Bool()
    static var timer = false
    static var segundos = 300
}

extension String{
    
    //Date formatter
    func toDateTime() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()

        //Parse into
        
        dateFormatter.dateFormat = "HH:mm"
        
        let dateFromString = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
    
    
}

class createTaskViewController: UIViewController, UINavigationControllerDelegate, UNUserNotificationCenterDelegate{

    //MARK: UI Elements
    @IBOutlet weak var taskTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //VARS
    let defaults = UserDefaults.standard
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];
    let ref = Database.database().reference(fromURL: "Typeyourdatabaseurlhere.com")
    var timeFromFir = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationItem.rightBarButtonItem?.title = "Add"
        
        retrieve()
        retrieveTime()
        
        //Creation of the one bordered Text Field
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.flatMint.cgColor
        border.frame = CGRect(x: 0, y: taskTF.frame.size.height - width, width:  taskTF.frame.size.width, height: taskTF.frame.size.height)
        border.borderWidth = width
        taskTF.layer.addSublayer(border)
        taskTF.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Add Task Function
    
    func addTask(){
     let timeZone = NSTimeZone.local
       let user = Firebase.Auth.auth().currentUser
        
        //Check for empty text before proceeding
        if taskTF.text != "" {
            ref.child((user?.uid)!).child("task").setValue(taskTF.text!)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let finalTime = formatter.string(from: datePicker.date)
            ref.child((user?.uid)!).child("time").setValue(finalTime)
            ref.child((user?.uid)!).child("timeZone").setValue(timeZone.description)
            defaultsKeys.task = taskTF.text!
            defaultsKeys.time = datePicker.date
            
            //Set default keys (not useful at the moment as they are not retrieved)
            defaults.set(defaultsKeys.task, forKey: "Task")
            defaultsKeys.timeExistsFirebase = true
            defaults.set(defaultsKeys.time, forKey: "TimeExists")
            defaults.set(defaultsKeys.time, forKey: "Time")
            
            //Set the notifications at the date and time
            setNot()
            let MainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as UIViewController
            self.present(MainVC, animated: true, completion: nil)
        //If text field is empty - Error Handling
        }else{
            var alert = UIAlertController(title: "Oops!", message: "The task cannot be left empty!", preferredStyle: .alert)
            var alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }

        
    }
    
    //MARK: Retrieve time function
    func retrieveTime(){
        let user = Firebase.Auth.auth().currentUser
        let usersRef = ref.child((user?.uid)!).child("time").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            self.timeFromFir = snapshot.value as! String
            print(self.timeFromFir)
            var finalTime = self.timeFromFir.toDateTime()
            self.datePicker.date = finalTime
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //MARK: Retrieve task
    func retrieve(){
        let user = Firebase.Auth.auth().currentUser
        let usersRef = ref.child((user?.uid)!).child("task").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            var task = snapshot.value as! String
            print(task)
            self.taskTF.text = task
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    //MARK: Button to save
    @IBAction func addAction(_ sender: Any) {
        addTask()
    }
    
    
    //MARK: Set notifications
    func setNot(){
        
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
                
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "It's that time again"
        content.body = "This is your daily reminder to do the task: \(taskTF.text!)"
        content.sound = UNNotificationSound.default()
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let identifier = "fiveMinutes"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
        
    }

}

