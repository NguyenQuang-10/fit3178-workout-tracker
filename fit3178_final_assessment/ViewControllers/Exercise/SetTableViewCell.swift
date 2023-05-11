//
//  SetTableViewCell.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//

import UIKit

class SetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var intensityTextbox: UITextField!
    
    @IBOutlet weak var unitTextbox: UITextField!
    
    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var repTextbox: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
