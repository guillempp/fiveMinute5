//
//  recoverPasswordViewController.swift
//  fiveminutes
//
//  Created by Guillem Pérez on 1/22/19.
//  Copyright © 2019 Guillem Pérez. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class recoverPasswordViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    var ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func isValidEmail(testString:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testString)
    }
    
    func handleRecovery(){
        var emailValid = isValidEmail(testString: emailTF.text!)
        if emailValid == true{
            Auth.auth().sendPasswordReset(withEmail: emailTF.text!){ error in
                if error == nil{
                    let alert = UIAlertController(title: "Success!", message: "Take a look at your email inbox for instructions on how to change your password.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Email is not valid.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    @IBAction func resetPassword(_ sender: Any) {
        handleRecovery()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
