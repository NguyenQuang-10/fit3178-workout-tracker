//
//  SetTableViewCell.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//

import UIKit
/**
 Table View Cell for configuring set information
 */
class SetTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var intensityTextbox: UITextField!
    
    
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var unitTextbox: UITextField!
    
    
    @IBOutlet weak var indexLabel: UILabel!
    
    var indexPath: IndexPath?
    var displayingSet: ExerciseSetStruct?
    var delegate: editSetDelegate?
    
    
    @IBOutlet weak var repTextbox: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        intensityTextbox?.delegate = self
        unitTextbox?.delegate = self
        repTextbox?.delegate = self
        duration?.delegate = self
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == repTextbox {
            displayingSet?.repetition = Int(textField.text ?? "") ?? 0
            delegate?.updateSetAtRow(indexPath: indexPath!, updatedSet: displayingSet!)
        } else if textField == intensityTextbox {
            displayingSet?.intensity = Int(textField.text ?? "") ?? 0
            delegate?.updateSetAtRow(indexPath: indexPath!, updatedSet: displayingSet!)
        } else if textField == unitTextbox {
            displayingSet?.unit = textField.text!
            delegate?.updateSetAtRow(indexPath: indexPath!, updatedSet: displayingSet!)
        }  else if textField == duration {
            displayingSet?.duration = Int(textField.text!)!
            delegate?.updateSetAtRow(indexPath: indexPath!, updatedSet: displayingSet!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
