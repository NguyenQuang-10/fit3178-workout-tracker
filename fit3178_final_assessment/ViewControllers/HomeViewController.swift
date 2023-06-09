//
//  HomeViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 4/5/2023.
//

import UIKit
import UserNotifications
/**
 The home view controller, displays all the workout that the user has
 */
class HomeViewController: UIViewController, DatabaseListener, UITableViewDelegate, UITableViewDataSource, WorkoutScheduleDelegate, ActiveWorkoutListener {
    
    
    var schedule = [WeekDates]()
    
    var listenerType: ListenerType = .workout
    weak var databaseController: DatabaseProtocol?
    var allWorkouts: [Workout] = []
    var willShowWorkout: Workout?
    var activeWorkoutManager: ActiveWorkoutManager?
    
    
    @IBOutlet weak var workoutTableView: UITableView!
    
    func onWorkoutChange(change: DatabaseChange, workoutExercise: [Workout]) {
        allWorkouts = workoutExercise
        workoutTableView.reloadData()
    }
    
    func onAllExercisesChange(change: DatabaseChange, exercises: [Exercise]) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        workoutTableView.reloadData()
        
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
        
        databaseController?.syncWithOnline()
        
        activeWorkoutManager = appDelegate?.activeWorkoutManager
        activeWorkoutManager?.finishWorkout()
        activeWorkoutManager?.addListener(listener: self)
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (granted, error) in
            if !granted {
                print("Permission was not granted!")
                return
            }
        }
        workoutTableView.reloadData()
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if activeWorkoutManager?.active == true {
            return 2
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (activeWorkoutManager!.active == true && section == 1) || (activeWorkoutManager!.active == false && section == 0) {
            return allWorkouts.count
        } else {
            return 1
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if (activeWorkoutManager!.active == true && section == 1) || (activeWorkoutManager!.active == false && section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! WorkoutTableViewCell

            let workout = allWorkouts[indexPath.row]
            cell.title?.text = workout.name
            

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "activeWorkoutCell", for: indexPath) as! WorkoutTableViewCell
            

            return cell
        }
        
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
            let destination = segue.destination as! UINavigationController
            let target = destination.topViewController as! ViewWorkoutTableViewController
            target.displayingWorkout = willShowWorkout
        } else if segue.identifier == "activeWorkoutFromHomeSegue" {
            let destination = segue.destination as! UINavigationController
            let target = destination.topViewController as! ActiveWorkoutViewController
            
            target.manager = activeWorkoutManager
            activeWorkoutManager?.updateDelegate(delegate: target)
        }
    }
    
    func workoutWasActivated() {
        workoutTableView.reloadData()
    }
    
    func activeWorkoutWasFinished() {
        workoutTableView.reloadData()
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
