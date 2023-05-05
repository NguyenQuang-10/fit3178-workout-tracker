//
//  AddWorkoutViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 5/5/2023.
//

import UIKit

class AddWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WorkoutScheduleDelegate{
    var schedule: [WeekDates] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutMenuItem", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "Configure workouts"
            cell.contentConfiguration = content
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutMenuItem", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "Configure schedule"
            cell.contentConfiguration = content
            cell.selectionStyle = .none
            return cell
        }
    }
    

    @IBAction func cancelAddWorkout(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var createWorkout: UIButton!
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var menuTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTable.layer.cornerRadius = 10.0
        menuTable.delegate = self
        menuTable.dataSource = self

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    
    @IBAction func createNewWorkout(_ sender: Any) {
        if let newName = workoutName.text, newName != "" {
            let _ = databaseController?.addWorkout(name: newName, schedule: [])
            self.dismiss(animated: true)
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
