//
//  SyncController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 25/5/2023.
//

import Foundation

class SyncController: NSObject, DatabaseProtocol {
    func clearAllData() {
        
    }
    
    func syncWithOnline() {
        coreDataController?.clearAllData()
        
        var currentUser = firebaseController?.currentUser
        var userDocRef = firebaseController?.database.collection("user").document(currentUser!.uid)
        var userWorkoutColRef = userDocRef!.collection("workouts")
        var userExerciseRef = userDocRef!.collection("exercises")
        var userExerciseSetRef = userDocRef!.collection("exerciseSets")
        
        userExerciseRef.getDocuments { (querySnapshot, error) in
            for document in querySnapshot!.documents {
                print(document.data())
                let name = document.data()["name"] as! String
                let desc = document.data()["desc"] as! String
                let imageURL = document.data()["imageURL"] as! String
                let _ = self.coreDataController!.addExercise(name: name, desc: desc, imageURL: imageURL, id: document.documentID)
            }
            
        }
        
//        userWorkoutColRef.getDocuments { (querySnapshot, error) in
//            for document in querySnapshot!.documents {
//                let name = document.data()["name"]
//                let exercises = document.data()["exercises"]
//                let schedule = document.data()["schedule"]
//                
//                var setDataDict: Dictionary<Exercise, [ExerciseSetStruct]> = [:]
//                var exerciseSetArray: [Any] = []
//                for i in 0...exerciseSetArray.count {
//                    var exercise = exerciseSetArray[i] as! String
//                    userExerciseSetRef.document(exercise).getDocument { (doc, error) in
//                        let exerciseID = document.data()["exercise"] as! String
//                        let workoutID = document.data()["workout"] as! String
//                        let rep = document.data()["repetition"] as! Int
//                        let intensity = document.data()["intensity"] as! Int
//                        let unit = document.data()["unit"] as! String
//                        
//                        let _ = self.coreDataController?.addExerciseSet(rep: rep, intensity: intensity, unit: unit, exerciseID: exerciseID, workoutID: workoutID)
//                    }
//                }
//            }
//            
//            
//            
//            let _ = self.coreDataController?.addWorkout(name: <#T##String#>, schedule: <#T##[WeekDates]#>, setData: <#T##Dictionary<Exercise, [ExerciseSetStruct]>#>, id: <#T##String#>)
//        }
    }
    
    
    
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
