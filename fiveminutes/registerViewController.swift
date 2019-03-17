//
//  registerViewController.swift
//  fiveminutes
//
//  Created by Guillem Pérez on 10/29/17.
//  Copyright © 2017 Guillem Pérez. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    
    //@IBOutlet weak var repeatPasswordTF: UITextField!
    var ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        // Do any additional setup after loading the view.
        setTFsep()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setTFsep(){
        let border = CALayer()
        
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        
        border.frame = CGRect(x: 0, y: emailTF.frame.size.height - width, width:  emailTF.frame.size.width, height: emailTF.frame.size.height)
        
        //border3.frame = CGRect(x: 0, y: repeatPasswordTF.frame.size.height - width, width:  passwordTF.frame.size.width, height: passwordTF.frame.size.height)
        
        border.borderWidth = width
        emailTF.layer.addSublayer(border)
        emailTF.layer.masksToBounds = true

        
        //border3.borderWidth = width
        //repeatPasswordTF.layer.addSublayer(border3)
        //repeatPasswordTF.layer.masksToBounds = true
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
    
    func addTask(){
      
        let user = Firebase.Auth.auth().currentUser
        let timeZone = NSTimeZone.local
            ref.child((user?.uid)!).child("task").setValue("Set up your task with + button")
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
        let finalTime = "12:00"
            ref.child((user?.uid)!).child("time").setValue(finalTime)
            ref.child((user?.uid)!).child("timeZone").setValue(timeZone.description)
    
        
        
    }
    
    func handleRegister(){
        var emailValid = isValidEmail(testString: emailTF.text!)
        if emailValid == true{
            Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
                if error != nil{
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    
                    //MARK: Username tag adder. This + Settings
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print("Success")
                    user?.user.sendEmailVerification(completion: nil)
                    self.addTask()
                    let mainView =  self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! UIViewController
                    self.present(mainView, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(mainView, animated: true)
                }
                
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "Seems like your email is not valid", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func registerButton(_ sender: Any) {
        handleRegister()
        
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
