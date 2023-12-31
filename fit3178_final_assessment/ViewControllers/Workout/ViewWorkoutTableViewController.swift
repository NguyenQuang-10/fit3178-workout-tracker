//
//  ViewWorkoutTableViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 12/5/2023.
//

import UIKit

/**
    Display the information about a workout
 */
class ViewWorkoutTableViewController: UITableViewController {

    var displayingWorkout: Workout? // workout to be display
    var exerciseDict: Dictionary<Exercise, [ExerciseSet]> = [:] // contains the exercises and their set data of the workout
    var membershipSet: Set<Exercise> = Set() // used to initialise exerciseDict and exerciseList
    var exerciseList: [Exercise] = [] // the exercise in the workout
    
    // translate int into week dates
    let dateForInt: Dictionary<Int, String> = [
        2: "Monday",
        3: "Tuesday",
        4: "Wednesday",
        5: "Thursday",
        6: "Friday",
        7: "Saturday",
        8: "Sunday"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialises exerciseDict and exerciseList
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
        
        /**
                        Sorts the exerciseList in the correct order (note that the order of the workout is stored in all ExerciseSetStruct of the exercise under .order (#not setOrder as that is for the or
                        ordering of the set inside an exercise))
         */
        
        exerciseList = exerciseList.sorted { (e1, e2) -> Bool in
            return exerciseDict[e1]![0].order < exerciseDict[e2]![0].order
        }
        
        /**
                        Sort the ordering of the set inside each exercise (see above)
         */
        
        for e in exerciseList {
            exerciseDict[e] = exerciseDict[e]?.sorted{ (s1,s2) -> Bool in 
                return s1.setOrder < s2.setOrder
            }
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
        if indexPath.section == 0 { // Display the details of the workout we are displaying
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutDetailCell", for: indexPath)

            var content = cell.defaultContentConfiguration()
            content.text = displayingWorkout?.name
            if displayingWorkout!.schedule!.count > 0 {
                content.secondaryText = "Every "
                for i in 0...displayingWorkout!.schedule!.count - 1 {
                    let dateInt = displayingWorkout!.schedule![i]
                    if i < displayingWorkout!.schedule!.count - 1 {
                        content.secondaryText! += dateForInt[dateInt]! + ", "
                    } else {
                        content.secondaryText! += dateForInt[dateInt]!
                    }
                    
                }
            }
            
            cell.contentConfiguration = content

            return cell
        } else { // display the details of each exercise and their set for the workout we are displaying
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)

            var content = cell.defaultContentConfiguration()
            let exercise = exerciseList[indexPath.section - 1]
            let exerciseSet = exerciseDict[exercise]![indexPath.row]
            content.text = "\(indexPath.row + 1). Reps: \(exerciseSet.repetition) Intensity: \(exerciseSet.intensity) \(exerciseSet.unit ?? "") for \(exerciseSet.duration) minutes"
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
        /**
         Set the activeWorkoutManager for the view controller and load the data about the workout that about to be started to the activeWorkoutManager
         */
        if segue.identifier == "startWorkoutSegue" {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let activeWorkoutManager = appDelegate?.activeWorkoutManager
            
            let destination = segue.destination as! UINavigationController
            let target = destination.topViewController as! ActiveWorkoutViewController
            
            target.workoutName = displayingWorkout?.name
            activeWorkoutManager?.delegate = target
            activeWorkoutManager?.loadWorkoutData(workout: displayingWorkout!, exerciseSets: exerciseDict)
            target.manager = activeWorkoutManager
            
            
        }
    }
}
