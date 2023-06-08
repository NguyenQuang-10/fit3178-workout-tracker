//
//  FinishedWorkoutViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 8/6/2023.
//

import UIKit
import AVFoundation

class FinishedWorkoutViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButtonOutler: UIButton!
    var audioRecorder: AVAudioRecorder?
    var recordingSession: AVAudioSession?
    var newAudioFileUUID = UUID().uuidString

    @IBAction func recordButton(_ sender: Any) {
        recordingSession = AVAudioSession.sharedInstance()

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
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func startRecording(uuid: String) {
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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToHome(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
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