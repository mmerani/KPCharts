//
//  SignUpViewController.swift
//  KPCharts
//
//  Created by Michael Merani on 4/1/17.
//  Copyright © 2017 Michael Merani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldReEnterPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ("Sign Up")
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "mainbackground")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.view.clipsToBounds = true
        //self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        btnSignUp.layer.cornerRadius = 25;
       

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didSelectSignUp(_ sender: UIButton) {
        if txtFieldEmail.text == "" || txtFieldFirstName.text == "" || txtFieldLastName.text == "" || txtFieldPassword.text == "" || txtFieldReEnterPassword.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please fill out all fields", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
        } else if txtFieldPassword.text != txtFieldReEnterPassword.text {
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }else {
            let email = txtFieldEmail.text
            let pwd = txtFieldPassword.text
            
            FIRAuth.auth()?.createUser(withEmail: email!, password: pwd!, completion: { (user, error) in
                if error != nil {
                    print("MIKE: Unable to authenticate with Firebase using email")
                    print(error!)
                } else {
                
                    print("MIKE: Successfully authenticated with Firebase")
               
                }
                
                })
            }
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
