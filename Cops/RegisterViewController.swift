//
//  RegisterViewController.swift
//  Cops
//
//  Created by siddhant on 10/13/17.
//  Copyright © 2017 siddhant. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backToLoginButton: UIButton!
    
    var effect : UIVisualEffect!
    
    @IBOutlet weak var panelBlurEffect: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 4
        registerButton.layer.borderColor = UIColor.white.cgColor
        backToLoginButton.layer.cornerRadius = 4
        registerButton.layer.borderWidth = 0.5
        backToLoginButton.layer.borderColor = UIColor.white.cgColor
        backToLoginButton.layer.borderWidth = 0.5
        panelBlurEffect.layer.cornerRadius = 8
        panelBlurEffect.clipsToBounds = true
        panelBlurEffect.layer.borderWidth = 1
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "backToLogin" {
            return true
        }else {
            return false
        }
    }
    func errorMessage(message:String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle:.alert)
        UIView.animate(withDuration: 0.0) {
            
        }
        errorAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
            
            
        }))
        present(errorAlert, animated: true, completion: nil)
    }

    @IBAction func registerActionButton(_ sender: UIButton) {
        if let email = emailTextField.text, let pass = passwordTextField.text, let username = userNameTextField.text {
            Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                if error != nil {
                    if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                        switch errCode {
                        case .emailAlreadyInUse:
                            self.errorMessage(message: "Email already in use")
                        case .invalidEmail:
                            self.errorMessage(message: "Invalid email")
                        default:
                            break
                        }
                    }
                    print(error.debugDescription)
                }else if self.passwordTextField.text != self.confirmPasswordTextField.text{
                    self.errorMessage(message: "Password do not match!")
                }else {
                    let dbRef = Database.database().reference().child("User-Info")
                    dbRef.child((user?.uid)!).setValue(["Email": email, "Password": pass, "Username": username, "URL": "https://firebasestorage.googleapis.com/v0/b/cops-b09e1.appspot.com/o/1200px-Color_icon_gray_v2.svg.png?alt=media&token=d560832e-deed-403a-80e2-faa38d014a33"])
                    self.errorMessage(message: "Email Registered!")
                    self.performSegue(withIdentifier: "backToLogin", sender: self)
                }
            })
        }
    }
    
    @IBAction func backToLoginActionButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backToLogin", sender: self)
    }
    
}
