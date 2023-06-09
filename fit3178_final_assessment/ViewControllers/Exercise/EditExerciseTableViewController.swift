//
//  EditExerciseTableViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 11/5/2023.
//

import UIKit

/**
 View that allow the user the change and configure sets of an exercise
 */
class EditExerciseTableViewController: UITableViewController, editSetDelegate {
    /**
        Update the data of a set at a indexPath in the table view
     */
    func updateSetAtRow(indexPath: IndexPath, updatedSet: ExerciseSetStruct) {
        sets[indexPath.row] = updatedSet
        tableView.reloadData()
    }
    
    /**
     Save the changes made to the sets of the workout
     */
    @IBAction func saveSets(_ sender: Any) {
        delegate?.updateSetsForExercise(exercise: editingExercise!, exericseSets: sets)
        navigationController?.popViewController(animated: true)
    }
    
    /**
        Add a new set to the exercise
     */
    @IBAction func addNewSet(_ sender: Any) {
        var blankSet = ExerciseSetStruct(repetition: 0, intensity: 0, unit: "", order: 0, duration: 0, setOrder: sets.count)
        sets.append(blankSet)
        tableView.reloadData()
    }
    
    var delegate: EditExerciseDelegate? // the class responsible for configuring set data
    var sets: [ExerciseSetStruct] = [] // the sets of the exercise we are currently configuring
    var editingExercise: Exercise? // the exercise we are configuring

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sort the sets in the correct order (stored in setOrder in ExerciseSetStruct, NOT .order, that stores the order of the exercise in the workout)
        sets = (delegate?.getSetsForExercise(exercise: editingExercise!))!
        sets = sets.sorted { (s1, s2) -> Bool in
            s1.setOrder < s2.setOrder
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 || section == 2{
            return 1
        } else if section == 1 {
            return sets.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 { // configure content for the cell that responisble to configuring the set
            let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath) as! SetTableViewCell

            cell.delegate = self
            cell.indexLabel?.text = "\(indexPath.row + 1)"
            cell.repTextbox?.text = "\(sets[indexPath.row].repetition)"
            cell.intensityTextbox?.text = "\(sets[indexPath.row].intensity)"
            cell.unitTextbox?.text = sets[indexPath.row].unit
            cell.duration?.text = String(sets[indexPath.row].duration)
            cell.indexPath = indexPath
            cell.displayingSet = sets[indexPath.row]
            

            return cell
        } else if indexPath.section == 2 { // contains a button that add sets to the exercise
            let cell = tableView.dequeueReusableCell(withIdentifier: "addSetCell", for: indexPath)
            return cell
        } else { // contains information about how many set is in this exercise
            let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath)

            var content = cell.defaultContentConfiguration()
            content.text = "\(sets.count)"
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

}
