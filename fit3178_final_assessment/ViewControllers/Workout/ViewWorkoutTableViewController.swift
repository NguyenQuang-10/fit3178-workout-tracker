//
//  ViewWorkoutTableViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 12/5/2023.
//

import UIKit

class ViewWorkoutTableViewController: UITableViewController {

    var displayingWorkout: Workout?
    var exerciseDict: Dictionary<Exercise, [ExerciseSet]> = [:]
    var membershipSet: Set<Exercise> = Set()
    var exerciseList: [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let exerciseSetsUnordered = displayingWorkout?.exercises?.allObjects
        for es in exerciseSetsUnordered! {
            let exerciseSet = es as! ExerciseSet
            
            if let exercise = exerciseSet.exercise {
                
                if membershipSet.contains(exercise) {
                    exerciseDict[exercise]?.append(exerciseSet)
                } else {
                    exerciseList.append(exercise)
                    membershipSet.insert(exercise)
                    exerciseDict[exercise] = []
                    exerciseDict[exercise]?.append(exerciseSet)
                }
            }
            
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return exerciseList.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return exerciseDict[exerciseList[section - 1]]!.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Workout details"
        } else {
            return exerciseList[section - 1].name
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutDetailCell", for: indexPath)

            // Configure the cell...

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)

            var content = cell.defaultContentConfiguration()
            let exercise = exerciseList[indexPath.section - 1]
            let exerciseSet = exerciseDict[exercise]![indexPath.row]
            content.text = "\(indexPath.row + 1). Reps: \(exerciseSet.repetition) Intensity: \(exerciseSet.intensity) \(exerciseSet.unit ?? "Ambatukam")"
            cell.contentConfiguration = content

            return cell
        }
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startWorkoutSegue" {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let activeWorkoutManager = appDelegate?.activeWorkoutManager
            
            let destination = segue.destination as! ActiveWorkoutViewController
            
            activeWorkoutManager?.delegate = destination
            activeWorkoutManager?.loadWorkoutData(workout: displayingWorkout!, exerciseSets: exerciseDict)
            destination.manager = activeWorkoutManager
            
            
        }
    }
}
