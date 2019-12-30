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
    
    
}
