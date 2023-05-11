//
//  CreateExerciseViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//

import UIKit

class CreateExerciseViewController: UIViewController {
    weak var databaseController: DatabaseProtocol?

    @IBOutlet weak var exerciseName: UITextField!
    @IBOutlet weak var exerciseDesc: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    

    @IBAction func saveExercise(_ sender: Any) {
        if let newName = exerciseName.text, newName != "", let newDesc = exerciseDesc.text, newDesc != "" {
            let _ = databaseController?.addExercise(name: newName, desc: newDesc, imageURL: "")
            navigationController?.popViewController(animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
