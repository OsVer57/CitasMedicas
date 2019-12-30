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
    
   
    init(dictionary: [String: Any]) {
        
        self.name = dictionary["name"] as? String ?? ""
        self.specialism = dictionary["specialism"] as? String ?? ""
        self.professionalID = dictionary["professionalID"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
    }
    init(Name:String,Specialism:String,ProfessionalID:String,Location:String) {
        self.name = Name
        self.specialism = Specialism
        self.professionalID = ProfessionalID
        self.location = Location
    }
}
