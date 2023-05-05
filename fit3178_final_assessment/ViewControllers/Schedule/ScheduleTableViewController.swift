//
//  ScheduleTableViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 5/5/2023.
//

import UIKit

class ScheduleTableViewController: UITableViewController, AddWorkoutDelegate {

    var schedule = [WeekDates]()
    var selectedIndexPaths = Set<IndexPath>()
    var workoutScheduleDelegate: WorkoutScheduleDelegate?
    let dateAtRow: Dictionary<Int, String> = [
        0: "Monday",
        1: "Tuesday",
        2: "Wednesday",
        3: "Thursday",
        4: "Friday",
        5: "Saturday",
        6: "Sunday"
    ]
    let rowAtDate: Dictionary<WeekDates, Int> = [
        .monday: 0,
        .tuesday: 1,
        .wednesday: 2,
        .thursday: 3,
        .friday: 4,
        .saturday: 5,
        .sunday: 6
    ]
    
    @IBAction func saveSchedule(_ sender: Any) {
        workoutScheduleDelegate?.schedule = self.schedule
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = true
        schedule = workoutScheduleDelegate!.schedule
        for date in schedule {
            selectedIndexPaths.insert(IndexPath(row: rowAtDate[date]!, section: 0))
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        
        
        var content = cell.defaultContentConfiguration()
        content.text = String(dateAtRow[indexPath.row]!)
        cell.contentConfiguration = content
        
//        if selectedIndexPaths.contains(indexPath) {
//            cell.accessoryType = .checkmark
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(indexPath)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            print(schedule.count)
            schedule.removeAll(where: { $0 == WeekDates(rawValue: indexPath.row) })
            print(schedule.count)
        } else {
            selectedIndexPaths.insert(indexPath) //select
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            schedule.append(WeekDates(rawValue: indexPath.row)!)
        }
    
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(indexPath)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            schedule.removeAll(where: { $0 == WeekDates(rawValue: indexPath.row) })
        } else {
            selectedIndexPaths.insert(indexPath) //select
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            schedule.append(WeekDates(rawValue: indexPath.row)!)
        }
            
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = selectedIndexPaths.contains(indexPath) ? .checkmark : .none
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
