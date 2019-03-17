//
//  timerViewController.swift
//  fiveminutes
//
//  Created by Guillem Pérez on 11/4/17.
//  Copyright © 2017 Guillem Pérez. All rights reserved.
//

import UIKit
import NotificationCenter
import UserNotifications
import GoogleMobileAds


var currentVC: UIViewController!

class timerViewController: UIViewController, UNUserNotificationCenterDelegate, GADBannerViewDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var seconds = defaultsKeys.segundos
    var timer = Timer()
    
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];
    
    var isTimerRunning = false
    var resumeTapped = false
    
    
    
    //MARK: - IBActions
    @IBAction func startButtonTapped(_ sender: UIButton) {
            runTimer()
        


    }
    
    func runTimer() {
        if isTimerRunning == false{
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        startButton.setTitle("Stop", for: .normal)

            setNot()
        }else{
            timer.invalidate()
            isTimerRunning = false
            startButton.setTitle("Start", for: .normal)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }

    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        seconds = 300
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        self.startButton.setTitle("Start", for: .normal)
        
        
        
    }
    
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
            
            //labelButton.setTitle(timeString(time: TimeInterval(seconds)), for: UIControlState.normal)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }

    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentVC = self
        
        timerLabel.text = timeString(time: TimeInterval(defaultsKeys.segundos))
        
        startButton.layer.cornerRadius = 5
        
        resetButton.layer.cornerRadius = 5
        
        //self.navigationItem.backBarButtonItem?.tintColor = .white
        let navBarFont2 = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentVC = self
        
    }
    
    
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
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
        
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
        
    }
    
}


