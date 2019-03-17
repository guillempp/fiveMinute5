//
//  ViewController.swift
//  fiveminutes
//
//  Created by Guillem Pérez on 10/29/17.
//  Copyright © 2017 Guillem Pérez. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase
import UserNotifications



class ViewController: UIViewController, UINavigationControllerDelegate{

    //Outlets
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    //Constants
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];
    //Variables
    var ref = Database.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        retrieve()
        changeRadius()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationItem.leftBarButtonItem?.title = "Settings"
        
        taskLabel.sizeToFit()
        
        
        
    
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    //MARK: Retrieve User Function
    func retrieve(){
        let user = Firebase.Auth.auth().currentUser
        let usersRef = ref.child((user?.uid)!).child("task").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            var task = snapshot.value as! String
            print(task)
            self.taskLabel.text = task
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func changeRadius(){
        
        startButton.layer.cornerRadius = 10
        
    }
    
    //MARK: Set Notification function
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
        content.title = "Time is up!"
        content.body = "You are done for today! You can keep working (highly encouraged!) or you can go do whatever else you want, you deserve it!!"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
        
    }
    

 
    //MARK: Checker function for notification status
    func initNotificationSetupCheck() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(
                completionHandler: { (error) in
                if error != nil{
                    var alertView = UIAlertController(title: "Oops!", message: "You won't recieve any notifications, you should turn them on your Settings", preferredStyle: .alert)
                    var alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertView.addAction(alertAction)
                    self.present(alertView, animated: true, completion: nil)
                } else {

                }
            })
        } else {
            // Fallback on earlier versions
        }
    }


}

