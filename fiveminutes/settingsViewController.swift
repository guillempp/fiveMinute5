//
//  settingsViewController.swift
//  fiveminutes
//
//  Created by Guillem Pérez on 11/8/17.
//  Copyright © 2017 Guillem Pérez. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import GoogleMobileAds

class settingsViewController: UIViewController, UINavigationControllerDelegate {

    
    //var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = .white
        //let navBarFont2 = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navBarFont2, NSAttributedStringKey.foregroundColor: UIColor.white]
        //self.navigationItem.title = "fiveMinutes"
        
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Log the user out
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        let mainView =  self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! UIViewController
        self.present(mainView, animated: true, completion: nil)
    }
    
    //Stop notifications
    @IBAction func stopNotifications(_ sender: Any) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["fiveMinutes"])
        
        var alertView = UIAlertController(title: "Done", message: "You won't recieve any more reminders from us", preferredStyle: .alert)
        var alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    
    
}
