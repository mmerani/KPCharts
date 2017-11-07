//
//  SignInViewController.swift
//  KPCharts
//
//  Created by Michael Merani on 4/1/17.
//  Copyright © 2017 Michael Merani. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        txtFieldPassword.delegate = self
        txtFieldUsername.delegate = self
//        btnSignIn.layer.cornerRadius = btnSignIn.frame.height/2;
//        btnSignUp.layer.cornerRadius = btnSignUp.frame.height/2;


    }
    
    @IBAction func tappedSignUp(_ sender: Any) {
        print("Tapped")
        let alert = UIAlertController.init(title: "Create Account", message: "Enter the following information.", preferredStyle: .alert)
        alert.addTextField { (email) in
            email.placeholder = "email"
            email.keyboardType = .emailAddress
        }
        alert.addTextField { (password1) in
            password1.placeholder = "password (at least 6 characters)"
            password1.isSecureTextEntry = true
        }
        alert.addTextField { (password2) in
            password2.placeholder = "password verification"
            password2.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (theAlert) in
            let email = alert.textFields?[0]
            let password1 = alert.textFields?[1]
            let password2 = alert.textFields?[2]
            
            let emailText = email?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password1Text = password1?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password2Text = password2?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if emailText == "" || password1Text == "" || password2Text == "" {
                self.showAlert(alertTitle: "Error", alertMessage: "Please fill out all fields", alertActionTitle: "OK")
            } else if password1Text != password2Text {
                self.showAlert(alertTitle: "Error", alertMessage: "Passwords do not match", alertActionTitle: "OK")
            }else {
                let email = emailText
                let testEmail = self.validateEmail(enteredEmail: email!)
                if !testEmail {
                   self.showAlert(alertTitle: "Not a valid email", alertMessage: "Please enter a valid email address", alertActionTitle: "OK")
                }
                let pwd = password1Text
                if (pwd?.characters.count)! < 6 {
                    self.showAlert(alertTitle: "Error", alertMessage: "Password must be at least 6 characters", alertActionTitle: "OK")
                }
                
                Auth.auth().createUser(withEmail: email!, password: pwd!, completion: { (user, error) in
                    if error != nil {
                        
                        if (error?._code)! == 17007 {
                            self.showAlert(alertTitle: "Error", alertMessage: "The email address is already in use by another account", alertActionTitle: "Try Again")
                        } else {
                            self.showAlert(alertTitle: "Error", alertMessage: "Unable to authenticate with Firebase using email", alertActionTitle: "Try Again")
                        }
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChartData"), object: nil)
                        self.showAlert(alertTitle: "Success!", alertMessage: "Please Sign In", alertActionTitle: "OK")
                    }
                })
            }
        }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(alertTitle: String, alertMessage: String, alertActionTitle: String){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: alertActionTitle, style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func tappedSignIn(_ sender: Any) {
        if txtFieldUsername.text == "" || txtFieldPassword.text == ""{
            self.showAlert(alertTitle: "Error", alertMessage: "Please fill out all fields", alertActionTitle: "OK")
        } else {
            
            let email = txtFieldUsername.text
            let pwd = txtFieldPassword.text
            Auth.auth().signIn(withEmail: email!, password: pwd!, completion: { (user, error) in
                if error == nil {
                    print("MIKE: user authenticated with Firebase")
                    if let user = user {
                        let userData = ["email": user.email!]
                        self.finishSigningIn(id: user.uid, userData: userData)
                    }
                    //self.finishSigningIn()
                    
                } else {
                    // error code
                }
            })
        }
    }
    
    @IBAction func tappedForgotPassword(_ sender: Any) {
        let alert = UIAlertController.init(title: "", message: "Enter your email", preferredStyle: .alert)
        alert.addTextField { (email) in
            email.placeholder = "email"
            email.keyboardType = .emailAddress
        }
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (theAlert) in
            let email = alert.textFields?[0]
            let emailText = email?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let validEmail = self.validateEmail(enteredEmail: (email?.text)!)
            if validEmail {
                Auth.auth().sendPasswordReset(withEmail:emailText!, completion: { (error) in
                    if error != nil{
                        self.showAlert(alertTitle: "Error", alertMessage: "Please try again", alertActionTitle: "OK")
                    } else {
                        self.showAlert(alertTitle: "Success", alertMessage: "Password reset has been sent to your email", alertActionTitle: "OK")
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    func finishSigningIn(id: String, userData: Dictionary<String, String>) {
        //let mainHomeVC = HomeScreenViewController()
        //self.navigationController?.pushViewController(mainHomeVC,animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChartData"), object: nil)
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(id, forKey: "uid")
        UserDefaults.standard.synchronize()
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
