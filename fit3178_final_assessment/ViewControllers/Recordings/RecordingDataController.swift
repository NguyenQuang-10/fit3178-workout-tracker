//
//  RecordingDataController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 8/6/2023.
//

import Foundation

// database controller responsible for storing and retrieving data about the recording note
protocol RecordingDataController {
    func addNewAudioRecord(title: String, uuid: String)
    func getAllRecordingInfo() -> [WorkoutRecording]
}
