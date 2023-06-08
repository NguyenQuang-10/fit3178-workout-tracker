//
//  RecordingTableViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 8/6/2023.
//

import UIKit
import AVFoundation



class RecordingTableViewController: UITableViewController {
    
    var dataController: RecordingDataController? // the database controller to fetch recording info from
    var recordingDatas: [WorkoutRecording] = [] // the title and uuid for each audio recording

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.coreDataController
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        recordingDatas = (dataController?.getAllRecordingInfo())!
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
        return recordingDatas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = recordingDatas[indexPath.row].title
        cell.contentConfiguration = content

        return cell
    }
    
    func getDocumentsDirectory() -> URL { // return the URL representing the directory of the document directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // plays the audio corresponding to the row
    var audioPlayer: AVAudioPlayer?;
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uuid = recordingDatas[indexPath.row].uuid!
        print("UUID: " + uuid)
        
        let audiofilePath = getDocumentsDirectory().appendingPathComponent(uuid + ".m4a")

        //Write name of your audio at **myaudio.mp3**

        //now you can use anywhere audiofilePath as String like

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audiofilePath)
            self.audioPlayer?.play()
        } catch {
            print("Error playing audio")
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
