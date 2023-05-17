//
//  AddExerciseTableViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 10/5/2023.
//

import UIKit

class AddExerciseTableViewController: UITableViewController, DatabaseListener, UISearchBarDelegate {
    var listenerType: ListenerType = .exercise
    weak var databaseController: DatabaseProtocol?
    var delegate: AddExerciseDelegate?
        
 
    func onWorkoutChange(change: DatabaseChange, workoutExercise: [Workout]) {
        
    }
    
    func onAllExercisesChange(change: DatabaseChange, exercises: [Exercise]) {
        userAddedExercise = exercises
        if firstLoad {
            exercisesInView = exercises
            firstLoad = false
        }
        tableView.reloadData()
    }
    
    
    var exercisesInView: [Exercise] = []
    var userAddedExercise: [Exercise] = []
    var apiExercise: [Exercise] = []
    var firstLoad = true
    var indicator = UIActivityIndicatorView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            exercisesInView = userAddedExercise
            tableView.reloadData()
        } else if selectedScope == 1 {
            exercisesInView = apiExercise
            tableView.reloadData()
        }
    }
    
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
        
            print(apiResult)
        
        }
            catch let error {
                print(error)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchText = searchBar.text;
        guard searchText != nil || searchText != "" else {
            return;
        }
            apiExercise.removeAll()
            tableView.reloadData()
        
            
            
            navigationItem.searchController?.dismiss(animated: true)
            indicator.startAnimating()
            
            Task {
                URLSession.shared.invalidateAndCancel()
                await requestExerciseNamed(name: searchText!)
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
        delegate?.addExerciseToWorkout(exercise: exercisesInView[indexPath.row])
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
