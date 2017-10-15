//
//  SecondViewController.swift
//  Cops
//
//  Created by siddhant on 10/14/17.
//  Copyright © 2017 siddhant. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
class SecondViewController: UIViewController {
    
    var UID: String!
    var email: String!
    var menuShowing = true
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var recruitmentButton: UIButton!
    
    @IBOutlet weak var designsButton: UIButton!

    @IBOutlet weak var blackMarketButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        decorateButton(button: recruitmentButton)
        decorateButton(button: designsButton)
        decorateButton(button: blackMarketButton)
        decorateButton(button: settingsButton)
        print(UID)
        print(email)
    }
    func decorateButton(button: UIButton) {
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func menuButton(_ sender: UIButton) {
        if menuShowing {
            leadingConstraint.constant = -200
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else {
            leadingConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
    }
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child(UID)
        let image = #imageLiteral(resourceName: "Low-poly")
        if let uploadData = UIImageJPEGRepresentation(image, 0.5) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    
                }else {
                    completion((metadata?.downloadURL()?.absoluteString)!)
                }
            })
        }
    }
    @IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
       
    }
    
    @IBAction func designActionButton(_ sender: Any) {
    }
    
    @IBAction func changePhotoAction(_ sender: Any) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "designsSegue" {
            let dvc = segue.destination as? TableViewController
            dvc?.barTitle = "Designs"
            dvc?.UID = UID
            dvc?.email = email
        }else if segue.identifier == "blackSegue" {
            let dvc = segue.destination as? TableViewController
            dvc?.barTitle = "Black Market (Buy/sell accounts)"
            dvc?.UID = UID
            dvc?.email = email
        }else if segue.identifier == "recruitmentSegue" {
            let dvc = segue.destination as? TableViewController
            dvc?.barTitle = "Recruitment"
            dvc?.UID = UID
            dvc?.email = email
        }
    }
   
}
