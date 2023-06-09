//
//  WorkoutTableViewCell.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 4/5/2023.
//

import UIKit

/**
 Display the information about a workout
 */
class WorkoutTableViewCell: UITableViewCell {


    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
