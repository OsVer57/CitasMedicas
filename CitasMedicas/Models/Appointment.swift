//
//  Appointment.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 24/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import Foundation

struct Appointment: Encodable {
    var date:String
    var time:String
    var doctorName:String
    var doctorSpecialism:String
    
}
