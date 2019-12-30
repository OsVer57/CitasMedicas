//
//  Doctors.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 24/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import Foundation

struct Doctors: Decodable {
    var name:String
    var specialism:String
    var professionalID:String
    var location:String
    
     /*
    var profile_image:String {
        set{}
        get{
            return "url de una imagen"
        }
    }
   
    init(dictionary: [String: Any]) {
        
        self.name = dictionary["name"] as? String ?? ""
        self.specialism = dictionary["specialism"] as? String ?? ""
        self.professionalID = dictionary["professionalID"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
    }*/
}
