//
//  ViewController.swift
//  Cops
//
//  Created by siddhant on 10/13/17.
//  Copyright © 2017 siddhant. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var mainBlurEffect: UIVisualEffectView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    var effect: UIVisualEffect!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        blurEffect.layer.borderWidth = 1
        blurEffect.layer.cornerRadius = 8
        blurEffect.clipsToBounds = true
        decorateButton(button: loginButton)
        decorateButton(button: registerButton)
    }
    
    func decorateButton(button: UIButton) {
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
    }
    func errorMessage(message:String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle:.alert)
        UIView.animate(withDuration: 0.0) {
            
        }
        errorAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
            
            
        }))
        present(errorAlert, animated: true, completion: nil)
    }

    @IBAction func loginActionButton(_ sender: UIButton) {
        if let email = emailTextField.text, let pass = passTextField.text {
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error != nil {
                    if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                        switch errCode {
                        case .wrongPassword:
                            print("wrong ")
                            self.errorMessage(message: "Wrong password")
                        case .invalidEmail:
                            print("Wrong email")
                            self.errorMessage(message: "Wrong email")
                        default:
                            break
                        }
                    }
                    print(error.debugDescription)
                }else {
                    let dbRef = Database.database().reference().child("User-Info")
                    dbRef.child((user?.uid)!).updateChildValues(["Password": pass])
                    self.user = User(email: email, uid: (user?.uid)!)
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            })
        }
    }
    
    @IBAction func registerActionButton(_ sender: UIButton) {
        
    }
    
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        let alert = UIAlertController(title: "Enter Email", message: "", preferredStyle: .alert)
        alert.addTextField { (field:UITextField) in
            field.placeholder = "Email!"
        }
        alert.addAction(UIAlertAction(title: "Send Email", style: .default, handler: { (action:UIAlertAction) in
            if let email = alert.textFields?.first {
                Auth.auth().sendPasswordReset(withEmail: email.text!, completion: { (error:Error?) in
                    if error != nil {
                        print(error.debugDescription)
                    }else {
                        print("Success")
                    }
                })
            }
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            
            let desViewController = segue.destination as? UINavigationController
            let VC = desViewController?.viewControllers.first as? SecondViewController
            VC?.UID = user.getUID()
            VC?.email = user.getEmail()
            let databaseRef = Database.database().reference()
            databaseRef.child("User-Info").queryOrderedByKey().observe(.value, with: { (snapshot) in
                for c in (snapshot.value as? NSDictionary)! {
                    if c.key as! String == self.user.getUID() {
                        let cc = c.value as! NSDictionary
                        let pic = cc["URL"] as? String ?? ""
                        if let url = NSURL(string: pic) {
                            if let data = NSData(contentsOf: url as URL) {
                                VC?.userImage.image = UIImage(data: data as Data)
                                
                            }
                        }
                    }
                }

                
            })
        }
    }
    
    
}












