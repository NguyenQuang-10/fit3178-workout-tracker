//
//  SyncController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 25/5/2023.
//

import Foundation

class SyncController: NSObject, DatabaseProtocol {
    func addExerciseSet(rep: Int, intensity: Int, unit: String, exerciseID: String, workoutID: String) -> AnyObject {
        return ExerciseSet()
    }
    
    
    var coreDataController: CoreDataController?
    var firebaseController: FirebaseController?
    
    func cleanup() {
        coreDataController!.cleanup()
    }
    
    func addListener(listener: DatabaseListener) {
        coreDataController!.addListener(listener: listener)
        firebaseController!.addListener(listener: listener)
    }
    
    func removeListener(listener: DatabaseListener) {
        coreDataController!.removeListener(listener: listener)
        firebaseController!.removeListener(listener: listener)
    }
    
    func addExercise(name: String, desc: String, imageURL: String, id: String) -> AnyObject {
        let _ = firebaseController!.addExercise(name: name, desc: desc, imageURL: imageURL, id: id)
        let coreExercise = coreDataController!.addExercise(name: name, desc: desc, imageURL: imageURL, id: id)
        
        return coreExercise
    }
    
    func deleteExercise(exercise: Exercise) {
        coreDataController!.deleteExercise(exercise: exercise)
        firebaseController!.deleteExercise(exercise: exercise)
    }
    
    func addWorkout(name: String, schedule: [WeekDates], setData: Dictionary<Exercise, [ExerciseSetStruct]>, id: String) -> AnyObject {
        let obj = coreDataController!.addWorkout(name: name, schedule: schedule, setData: setData, id: id)
        let _ = firebaseController!.addWorkout(name: name, schedule: schedule, setData: setData, id: id)
        
        return obj
    }
    
    
}
