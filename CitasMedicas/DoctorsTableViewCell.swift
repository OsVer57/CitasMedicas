//
//  DoctorsTableViewCell.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 24/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit

class DoctorsTableViewCell: UITableViewCell {
    @IBOutlet weak var imgDoctor: UIImageView!
    
    @IBOutlet weak var lblSpecialism: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
