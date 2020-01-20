//
//  AppintmentsTableViewCell.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 24/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit

class AppintmentsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDoctor: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSpecialism: UILabel!
    @IBOutlet weak var lblFolio: UILabel!
    
    @IBOutlet weak var lblDateAppointments: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
