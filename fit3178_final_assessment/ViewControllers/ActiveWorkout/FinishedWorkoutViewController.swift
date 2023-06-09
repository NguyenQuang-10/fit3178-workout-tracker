//
//  FinishedWorkoutViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 8/6/2023.
//

import UIKit
import AVFoundation

class FinishedWorkoutViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var recordButtonOutler: UIButton! // outlet for the record button
    
    // AV classes needed for audio recording
    var audioRecorder: AVAudioRecorder?
    var recordingSession: AVAudioSession?
    
    // the file name to be saved as, also the identifier for the audio note to be saved in coredata
    var newAudioFileUUID = UUID().uuidString
    var dataController: RecordingDataController? // the data controller responsible for managing information on audio notes
    var workoutName: String? // name of the finished workout

    // NOTE: the AVFoundation parts in this class are modified from the Hacking with Swift article from Abouts
    // Ask for permission to record, initializes the recording session and start recording
    @IBAction func recordButton(_ sender: Any) {
        recordingSession = AVAudioSession.sharedInstance() // get the recording Session

        // initializes the recording session and start recording
        do {
            try recordingSession!.setCategory(.playAndRecord, mode: .default)
            try recordingSession!.setActive(true)
            recordingSession!.requestRecordPermission() { allowed in
                DispatchQueue.main.async { [self] in
                    if allowed {
                        if audioRecorder == nil {
                            startRecording(uuid: self.newAudioFileUUID)
                            } else {
                                finishRecording(success: true)
                            }
                    } else {
                        print("Permission to record not allowed")
                    }
                }
            }
        } catch {
            print("Setting up audio session failed")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // recording was interrupted
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL { // get document directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // start the recording then
    // save info about the recording to coredata and save the recording it self to a new file in the document directory
    func startRecording(uuid: String) {
        let date = Date()
        let calendar = Calendar.current
        let day = String(calendar.component(.day, from: date))
        let month = String(calendar.component(.month, from: date))
        let year = String(calendar.component(.year, from: date))
        let dateTag =  day + "-" + month + "-" + year
        dataController?.addNewAudioRecord(title: workoutName! + "-" + dateTag, uuid: uuid)
        let audioFilename = getDocumentsDirectory().appendingPathComponent(uuid + ".m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder!.delegate = self
            audioRecorder!.record()

            recordButtonOutler.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    // handles when recording stops
    func finishRecording(success: Bool) {
        audioRecorder!.stop()
        audioRecorder = nil

        if success {
            recordButtonOutler.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButtonOutler.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the data controller responsible to saving recording information
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.coreDataController

        // Do any additional setup after loading the view.
    }
    
    // return to home if button is presssed
    @IBAction func backToHome(_ sender: Any) {
        navigationController?.dismiss(animated: true)
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
