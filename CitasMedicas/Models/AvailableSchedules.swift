//
//  AvailableSchedules.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 09/01/20.
//  Copyright © 2020 Macbook Pro Oscar. All rights reserved.
//

import Foundation

struct AvailableSchedules: Decodable {
    var schedules:String
    
    init(dictionary: [String: Any]) {
        
     self.schedules = dictionary["hora"] as? String ?? ""
        
    }
}
