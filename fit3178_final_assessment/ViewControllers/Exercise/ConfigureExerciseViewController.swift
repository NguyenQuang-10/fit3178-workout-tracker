//
//  ConfigureExerciseViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//

import UIKit

class ExerciseSetManager {
    var exercisesToSet: Dictionary<Exercise, [ExerciseSet]> = [:]
    var exerciseSet: Set<Exercise> = Set()
    var exercises: [Exercise] = []
    
    init(from: [ExerciseSet]) {
        for es in from {
            if exerciseSet.contains(es.exercise!) {
                exercisesToSet[es.exercise!]?.append(es)
            } else {
                exerciseSet.insert(es.exercise!)
                exercises.append(es.exercise!)
                exercisesToSet[es.exercise!] = []
                exercisesToSet[es.exercise!]?.append(es)
            }
        }
        print(getNumberOfExercises())
    }
    
    func getSetsForExercise(exercise: Exercise) -> [ExerciseSet]{
        return exercisesToSet[exercise]!
    }
    
    func getExerciseForIndex(index: Int) -> Exercise{
        return exercises[index]
    }
    
    func addNewExercise(exercise: Exercise) {
        exerciseSet.insert(exercise)
        exercisesToSet[exercise] = []
        exercises.append(exercise)
        
        print(getNumberOfExercises())
    }
    
    func getNumberOfExercises() -> Int {
        return exercisesToSet.count
    }
}

class ConfigureExerciseViewController: UIViewController, AddExerciseDelegate, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return (setManager?.getNumberOfExercises())!
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = setManager?.getExerciseForIndex(index: indexPath.row).name
            cell.contentConfiguration = content
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCountCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "\(String(describing: setManager?.getNumberOfExercises())))"
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func addExerciseToWorkout(exercise: Exercise) {
        print("Im runinnnngg")
        setManager?.addNewExercise(exercise: exercise)
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ConfigureExerciseDelegate?
    var setManager: ExerciseSetManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setManager = ExerciseSetManager(from: delegate!.exercises)
        
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
