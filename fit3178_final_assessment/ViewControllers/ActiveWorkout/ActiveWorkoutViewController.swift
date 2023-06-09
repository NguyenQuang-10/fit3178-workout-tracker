//
//  ActiveWorkoutViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 7/6/2023.
//

import UIKit

/**
    Display the current active workout with data from an ActiveWorkoutManager
 */
class ActiveWorkoutViewController: UIViewController, ActiveWorkoutDelegate {
    
    // move to the finished workout screen if active workout is finished
    func finishWorkout() {
        performSegue(withIdentifier: "finishedWorkoutSegue", sender: self)
    }
    
    var manager: ActiveWorkoutManager? // the manager for the state of the active workout
    var workoutName: String? // the name of the active workout
    
    // labels for the active workout state
    @IBOutlet weak var reps: UILabel!
    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var second: UILabel!
    
    @IBOutlet weak var currentSet: UILabel!
    @IBOutlet weak var numOfSets: UILabel!
    @IBOutlet weak var intensity: UILabel!
    @IBOutlet weak var label: UILabel!
    
    
    // update the label after every second
    func updateSecond(sec: Int) {
        if sec >= 10 {
            second.text = String(describing: sec)
        } else if sec > 0 {
            second.text = "0" + String(describing: sec)
        } else {
            second.text = "00"
        }
        
    }
    
    
    // update the label after every minute
    func updateMinute(min: Int) {
        if min >= 10 {
            minute.text = String(describing: min)
        } else if min > 0 {
            minute.text = "0" + String(describing: min)
        } else {
            minute.text = "00"
        }
    }
    
    
    // update the label when set is changed
    func updateSet(setData: ExerciseSet, num: Int, total: Int) {
        currentSet.text = String(describing: num)
        numOfSets.text = String(describing: total)
        intensity.text = String(describing: setData.intensity)
        reps.text = String(describing: setData.repetition)
        label.text = setData.unit! as String
    }
    
    // update the label when exercise changes
    func updateExercise(exercise: Exercise) {
        exerciseNme.text = exercise.name
        exerciseDesc.text = exercise.desc
    }
    
    
    // some label for exercise and workout details
    @IBOutlet weak var exerciseNme: UILabel!
    
    @IBOutlet weak var exerciseDesc: UILabel!
    
    
    @IBOutlet weak var workoutNameLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutNameLable.text = workoutName
        if manager?.active == false { // if the active workout manager isn't active, starts it
            manager?.startWorkout()
        }
        
        // Do any additional setup after loading the view.
    }
    

    // end the workout when this button is pressed
    @IBAction func endWorkoutButton(_ sender: Any) {
        manager?.finishWorkout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishedWorkoutSegue" {
            let destination = segue.destination as! FinishedWorkoutViewController
            destination.workoutName = workoutName
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
