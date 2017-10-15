//
//  User.swift
//  Cops
//
//  Created by siddhant on 10/13/17.
//  Copyright © 2017 siddhant. All rights reserved.
//

import Foundation
import UIKit

class User {
    let email : String
    let uid : String
    
    
    init( email: String, uid : String) {
        self.email = email
        self.uid = uid
    }
    
    func getEmail()->String {
        return email
    }
    func getUID()->String {
        return uid
    }
}
