//
//  ConfigureExerciseViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//

import UIKit
/**
 View controller allowing user to configure exercises inside the workout
 */
class ConfigureExerciseViewController: UIViewController, AddExerciseDelegate, UITableViewDelegate, UITableViewDataSource, EditExerciseDelegate {
    
    // all changes been saved, return to parent view controoler
    @IBAction func saveExercises(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // update the sets for a exercise in the workout then udpate the order (order of the exercise in the workout, stored in ExerciseSetStruct)
    func updateSetsForExercise(exercise: Exercise, exericseSets: [ExerciseSetStruct]) {
        let exerciseOrder = delegate?.exercises[exercise]![0].order
        delegate?.exercises[exercise] = exericseSets
        for i in 0...(delegate?.exercises[exercise]!.count)! - 1 {
            delegate?.exercises[exercise]?[i].order = exerciseOrder!
        }
    }
    
    // get all sets for an exercise in the workoutout
    func getSetsForExercise(exercise: Exercise) -> [ExerciseSetStruct] {
        return (delegate?.exercises[exercise])!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 { // allow user to configure the set if a exercise was selected
            editingExercise = exerciseKeys![indexPath.row]
            performSegue(withIdentifier: "editExerciseSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return (delegate?.exercises.count)!
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 { // contain name of the exercises in the workout
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = exerciseKeys![indexPath.row]!.name
            cell.contentConfiguration = content
            return cell
        } else { // contain the number of exercise in the workout
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCountCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "\(exerciseKeys!.count) exercises in this workout"
            cell.contentConfiguration = content
            return cell
        }
    }
    
    // add a new exercise to the workout with 1 blank set
    func addExerciseToWorkout(exercise: Exercise) {
        let newBlankSet = ExerciseSetStruct(repetition: 0, intensity: 0, unit: "", order: (delegate?.exercises.count)!, duration: 0, setOrder: 0)
        delegate?.exercises[exercise] = []
        delegate?.exercises[exercise]?.append(newBlankSet)
        exerciseKeys = Array((delegate?.exercises.keys)!)
        exerciseKeys = exerciseKeys?.sorted { (e1, e2) -> Bool in
            return (delegate?.exercises[e1!]![0].order)! < (delegate?.exercises[e2!]![0].order)!
        }
        

        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ConfigureExerciseDelegate?
    var editingExercise: Exercise?
    var exerciseKeys: [Exercise?]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sort the exercise by ExerciseSetStruct.order (ExerciseSetStruct.order is the same for all set in their exercise,
        // denotes the order that  the exercise should appear, don't confuse this with setOrder, which is different for
        // all set in a exercise, and denotes the order that the set appears in an exercise)
        exerciseKeys = Array((delegate?.exercises.keys)!)
        exerciseKeys = exerciseKeys?.sorted { (e1, e2) -> Bool in
            return (delegate?.exercises[e1!]![0].order)! < (delegate?.exercises[e2!]![0].order)!
        }
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addWorkoutSegue" {
            let destination = segue.destination as! AddExerciseTableViewController
            destination.delegate = self
        } else if segue.identifier == "editExerciseSegue" {
            let destination = segue.destination as! EditExerciseTableViewController
            destination.delegate = self
            destination.editingExercise = editingExercise
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
