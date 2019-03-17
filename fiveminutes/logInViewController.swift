//
//  logInViewController.swift
//  fiveminutes
//
//  Created by Guillem Pérez on 10/29/17.
//  Copyright © 2017 Guillem Pérez. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //try! Firebase.Auth.auth().signOut()
        
        
        
        self.navigationController?.isNavigationBarHidden = true
        setUsernameTF()

        
        //FIREBASE
        let ref = Database.database().reference(fromURL: "urltoyourdb.com")
        
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                let mainView =  self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! UIViewController
                self.present(mainView, animated: true, completion: nil)
                // User is signed in.
            } else {
                print("No user logged in")
            }
        }
    }

    /*override var preferredStatusBarStyle: UIStatusBarStyle{
     return .lightContent
     }*/
    
    
    //MARK: Change Username Text Field Properties
    func setUsernameTF(){
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: usernameTF.frame.size.height - width, width:  usernameTF.frame.size.width, height: usernameTF.frame.size.height)
        
        border.borderWidth = width
        usernameTF.layer.addSublayer(border)
        usernameTF.layer.masksToBounds = true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    @IBAction func logIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameTF.text!, password: passwordTF.text!) { (user, error) in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                if user?.user.isEmailVerified == true{
                    let mainView =  self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! UIViewController
                    self.present(mainView, animated: true, completion: nil)
                    
                }else{
                    let alert = UIAlertController(title: "Error", message: "Looks like your email is not verified.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                //self.present(mainView, animated: true, completion: nil)
                //self.navigationController?.pushViewController(mainView, animated: true)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    
}

