//
//  AddWorkoutViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 5/5/2023.
//

import UIKit

class AddWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WorkoutScheduleDelegate{
    var schedule: [WeekDates] = []
    
    let dateAtRow: Dictionary<Int, String> = [
        0: "Monday",
        1: "Tuesday",
        2: "Wednesday",
        3: "Thursday",
        4: "Friday",
        5: "Saturday",
        6: "Sunday"
    ]
    
    @IBOutlet weak var scheduleLabel: UILabel!
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            performSegue(withIdentifier: "workoutScheduleSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workoutScheduleSegue" {
            let destination = segue.destination as! ScheduleTableViewController
            destination.workoutScheduleDelegate = self
        }
    }
    

    @IBAction func cancelAddWorkout(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var createWorkout: UIButton!
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var menuTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scheduleLabel.text = "Schedule: "
        for date in schedule {
            scheduleLabel.text! += dateAtRow[date.rawValue]!
        }
    }
    
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
            let _ = databaseController?.addWorkout(name: newName, schedule: schedule)
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
