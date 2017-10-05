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
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSignIn.layer.cornerRadius = btnSignIn.frame.height/2;
        

    }
    
    @IBAction func tappedSignUp(_ sender: Any) {
        print("Tapped")
        let alert = UIAlertController.init(title: "Create Account", message: "Enter the following information.", preferredStyle: .alert)
        alert.addTextField { (email) in
            email.placeholder = "email"
            email.keyboardType = .emailAddress
        }
        alert.addTextField { (password1) in
            password1.placeholder = "password"
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
                let alertController = UIAlertController(title: "Error", message: "Please fill out all fields", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else if password1Text != password2Text {
                let alertController = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }else {
                let email = emailText
                let pwd = password1Text
                
                Auth.auth().createUser(withEmail: email!, password: pwd!, completion: { (user, error) in
                    if error != nil {
                        print("Unable to authenticate with Firebase using email")
                        print(error!)
                    } else {
                        
                        print("Successfully authenticated with Firebase")
                        let alertController = UIAlertController(title: "Success!", message: "Please Sign In", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                })
            }
        }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedSignIn(_ sender: Any) {
        if txtFieldUsername.text == "" || txtFieldPassword.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please fill out all fields", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }else {
            
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


    func finishSigningIn(id: String, userData: Dictionary<String, String>) {
        //let mainHomeVC = HomeScreenViewController()
        //self.navigationController?.pushViewController(mainHomeVC,animated: true)
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
