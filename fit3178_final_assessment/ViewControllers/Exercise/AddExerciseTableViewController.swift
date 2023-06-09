//
//  AddExerciseTableViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 10/5/2023.
//

import UIKit
/**
 Contains information about an exercise
 */
struct ExerciseData {
    var name: String
    var desc: String
    var imageURL: String
    var exerciseInDB: Exercise? // the NSManagedObject Exercise that is described by this struct
}

/**
 Alllow user to search and add an exercise to the workout, from exercise that has been added to their workout to workouts retrieved by an API
 */
class AddExerciseTableViewController: UITableViewController, DatabaseListener, UISearchBarDelegate {
    var listenerType: ListenerType = .exercise // listener type for database
    weak var databaseController: DatabaseProtocol? // database Controller
    var delegate: AddExerciseDelegate? // delegate responsible to add exercise to a workout
        
    // doesn't use workout information
    func onWorkoutChange(change: DatabaseChange, workoutExercise: [Workout]) {
        
    }
    
    // update the user added exercise
    func onAllExercisesChange(change: DatabaseChange, exercises: [Exercise]) {
        userAddedExercise.removeAll()
        let _ = exercises.map {
            var newUserAddedExercise = ExerciseData(name: $0.name!, desc: $0.desc!, imageURL: $0.imageURL!, exerciseInDB: $0)
            userAddedExercise.append(newUserAddedExercise)
        }
        if firstLoad {
            exercisesInView = userAddedExercise
            firstLoad = false
        }
        tableView.reloadData()
    }
    
    
    var exercisesInView: [ExerciseData] = [] // exercise that are in view of the table view
    var userAddedExercise: [ExerciseData] = [] // all exercise that has been added to the user account
    var apiExercise: [ExerciseData] = [] // all exercise retrieved from the api
    var firstLoad = true // true if this is the first time the view controller is loaded
    var indicator = UIActivityIndicatorView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstLoad = true
        databaseController?.addListener(listener: self)
        
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // manage searching of exercise
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchText = searchBar.text;
        guard searchText != nil || searchText != "" else {
            return;
        }
        apiExercise.removeAll()
        exercisesInView.removeAll()
        tableView.reloadData()
    
        // navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
        
        if searchBar.selectedScopeButtonIndex == 0 {
            exercisesInView.removeAll();
            let _ = userAddedExercise.map {
                if $0.name.contains(searchText!) {
                    exercisesInView.append($0)
                }
            }
            indicator.stopAnimating()
            tableView.reloadData()
        } else {
            Task {
                URLSession.shared.invalidateAndCancel()
                await requestExerciseNamed(name: searchText!)
            }
            
        }
    }
    
    // scope for searching
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            exercisesInView = userAddedExercise
            tableView.reloadData()
        } else if selectedScope == 1 {
            exercisesInView = apiExercise
            tableView.reloadData()
        }
    }
    
    
    // retrieve exercise from API
    func requestExerciseNamed(name: String) async {
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "api.api-ninjas.com"
          searchURLComponents.path = "/v1/exercises"
        searchURLComponents.queryItems = [
            URLQueryItem(name: "name", value: name)
        ]

        
        guard let requestURL = searchURLComponents.url else {
            print("Invalid URL.")
            return
        }
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.addValue("/uHxz1lcZJpBSh+l9YRqYQ==4BHdbsLblM9LU6zP", forHTTPHeaderField: "X-Api-Key")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            
            let decoder = JSONDecoder()
            let apiResult = try decoder.decode([ExerciseAPIData].self, from: data)
        
            apiExercise.removeAll()
            let _ = apiResult.map {
                let desc = $0.muscle + " | " +  $0.difficulty + " | " + $0.equipment
                var newApiExercise = ExerciseData(name: $0.name, desc: desc, imageURL: "")
                apiExercise.append(newApiExercise)
            }
            
            exercisesInView.removeAll()
            exercisesInView = apiExercise
            tableView.reloadData()
        
        }
            catch let error {
                print(error)
        }
    }

    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        super.viewDidLoad()
        
        firstLoad = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        
        searchController.searchBar.scopeButtonTitles = ["Added", "Suggested"]

        
        navigationItem.searchController = searchController
        // Ensure the search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                    view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])

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
    
        return exercisesInView.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let exerciseAtRow = exercisesInView[indexPath.row]
        content.text = exerciseAtRow.name
        content.secondaryText = exerciseAtRow.desc
        cell.contentConfiguration = content
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // add the exercise that the user selected to the workout
        let exerciseData = exercisesInView[indexPath.row]
        if let dbExercise = exerciseData.exerciseInDB, dbExercise != nil {
            delegate?.addExerciseToWorkout(exercise: dbExercise)
        } else {
            let newDbExercise = databaseController?.addExercise(name: exerciseData.name, desc: exerciseData.desc, imageURL: exerciseData.imageURL, id: UUID().uuidString)
            delegate?.addExerciseToWorkout(exercise: newDbExercise! as! Exercise)
        }
        navigationController?.popViewController(animated: true)
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
