//
//  HomeViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 4/5/2023.
//

import UIKit

class HomeViewController: UIViewController, DatabaseListener, UITableViewDelegate, UITableViewDataSource, WorkoutScheduleDelegate {
    var schedule = [WeekDates]()
    
    var listenerType: ListenerType = .workout
    weak var databaseController: DatabaseProtocol?
    var allWorkouts: [Workout] = []
    var willShowWorkout: Workout?
    
    let dateAtRow: Dictionary<Int, String> = [
        0: "Monday",
        1: "Tuesday",
        2: "Wednesday",
        3: "Thursday",
        4: "Friday",
        5: "Saturday",
        6: "Sunday"
    ]
    
    @IBOutlet weak var workoutTableView: UITableView!
    
    func onWorkoutChange(change: DatabaseChange, workoutExercise: [Workout]) {
        allWorkouts = workoutExercise
        workoutTableView.reloadData()
    }
    
    func onAllExercisesChange(change: DatabaseChange, exercises: [Exercise]) {
        // do nothing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    

    override func viewDidLoad() {
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allWorkouts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! WorkoutTableViewCell

        let workout = allWorkouts[indexPath.row]
        cell.title?.text = workout.name
        cell.subtitle?.text = String(workout.schedule!.count  )
        
        for date in workout.schedule! {
            cell.subtitle?.text! += dateAtRow[date]!
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        willShowWorkout = allWorkouts[indexPath.row]
        performSegue(withIdentifier: "showWorkoutSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWorkoutSegue" {
            let destination = segue.destination as! ViewWorkoutTableViewController
            destination.displayingWorkout = willShowWorkout
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
