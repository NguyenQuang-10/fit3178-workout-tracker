//
//  ConfigureExerciseViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//

import UIKit

class ConfigureExerciseViewController: UIViewController, AddExerciseDelegate, UITableViewDelegate, UITableViewDataSource, EditExerciseDelegate {
    func updateSetsForExercise(exercise: Exercise, exericseSets: [ExerciseSetStruct]) {
        
    }
    
    func getSetsForExercise(exercise: Exercise) -> [ExerciseSetStruct] {
        return (delegate?.exercises[exercise])!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
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
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = exerciseKeys![indexPath.row].name
            cell.contentConfiguration = content
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCountCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "\(exerciseKeys!.count)"
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func addExerciseToWorkout(exercise: Exercise) {
        print("Im runinnnngg")
        let newBlankSet = ExerciseSetStruct(repetition: 0, intensity: 0, unit: "")
        delegate?.exercises[exercise] = []
        delegate?.exercises[exercise]?.append(newBlankSet)
        exerciseKeys = Array((delegate?.exercises.keys)!)
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ConfigureExerciseDelegate?
    var editingExercise: Exercise?
    var exerciseKeys: [Exercise]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseKeys = Array((delegate?.exercises.keys)!)
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addWorkoutSegue" {
            print("Cheese")
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
