//
//  User.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 23/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import Foundation

struct User: Encodable {
    var name:String
    var firstLastName:String
    var secondLastName:String?
    var birthday:String
    var birthEntity:String
    var identification:String
    var email:String
    var password:String
    var photoFront:String
    var photoBack:String
    
    init(dictionary: [String: Any]) {
        
        self.name = dictionary["name"] as? String ?? ""
        self.firstLastName = dictionary["firstLastName"] as? String ?? ""
        self.secondLastName = dictionary["secondLastName"] as? String ?? ""
        self.birthday = dictionary["birthday"] as? String ?? ""
        self.birthEntity = dictionary["birthEntity"] as? String ?? ""
        self.identification = dictionary["identification"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.photoFront = dictionary["userphotoFront"] as? String ?? ""
        self.photoBack = dictionary["userphotoBack"] as? String ?? ""
        
        
    }
    init(Name:String,FirstLastName:String,SecondLastName:String,Birthday:String,BirthEntity:String,Identification:String,Email:String,Password:String,PhotoFront:String,PhotoBack:String) {
        self.name = Name
        self.firstLastName = FirstLastName
        self.secondLastName = SecondLastName
        self.birthday = Birthday
        self.birthEntity = BirthEntity
        self.identification = Identification
        self.email = Email
        self.password = Password
        self.photoFront = PhotoFront
        self.photoBack = PhotoBack
    }
}
