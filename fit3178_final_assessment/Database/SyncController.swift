//
//  SyncController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 25/5/2023.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestoreSwift

class SyncController: NSObject, DatabaseProtocol {
    func addExerciseSet(rep: Int, intensity: Int, unit: String, exerciseID: String, workoutID: String, order: Int, duration: Int, setOrder: Int) -> AnyObject {
        return ExerciseSet()
    }
    
    func clearAllData() {
        
    }
    
    /*
     Clear all data in coredate then sync with firebase
     */
    func syncWithOnline() {
        coreDataController?.clearAllData()
        
        var currentUser = firebaseController?.currentUser
        var userDocRef = firebaseController?.database.collection("user").document(currentUser!.uid)
        var userWorkoutColRef = userDocRef!.collection("workouts")
        var userExerciseRef = userDocRef!.collection("exercises")
        var userExerciseSetRef = userDocRef!.collection("exercisesSets")
        
        userExerciseRef.getDocuments { (querySnapshot, error) in
            for document in querySnapshot!.documents {
                print(document.documentID)
                let name = document.data()["name"] as! String
                let desc = document.data()["desc"] as! String
                let imageURL = document.data()["imageURL"] as! String
                let _ = self.coreDataController!.addExercise(name: name, desc: desc, imageURL: imageURL, id: document.documentID)
            }
            
            
            self.setUpWorkout(userExerciseSetRef: userExerciseSetRef, userWorkoutColRef: userWorkoutColRef)
            
        }
        
        
    }
    
    /*
     Helper function to sync data from firebase
     */
    func setUpWorkout(userExerciseSetRef: CollectionReference, userWorkoutColRef: CollectionReference) {
        userWorkoutColRef.getDocuments { (querySnapshot, error) in
            for document in querySnapshot!.documents {
                let name = document.data()["name"] as! String
                let exerciseSets = document.data()["exercises"] as! Array<String>
                let schedule = document.data()["schedule"] as! Array<Int>
                
                var weekDateSchedule: [WeekDates] = []
                schedule.map { weekDateSchedule.append(WeekDates(rawValue: $0)!) }
                
                var setDataDict: Dictionary<Exercise, [ExerciseSetStruct]> = [:]
                var callsLeft = exerciseSets.count
                if exerciseSets.count == 0 {
                    let _ = self.coreDataController?.addWorkout(name: name, schedule: weekDateSchedule, setData: [:], id: document.documentID)
                    continue
                }
                for i in 0...exerciseSets.count - 1 {
                    var exerciseSet = exerciseSets[i]
                    print(exerciseSet)
                    userExerciseSetRef.document(exerciseSet).getDocument { (setDoc, error) in
                        let exerciseID = setDoc!.data()!["exercise"] as! String
                        let workoutID = setDoc!.data()!["workout"] as! String
                        let rep = setDoc!.data()!["repetition"] as! Int
                        let intensity = setDoc!.data()!["intensity"] as! Int
                        let unit = setDoc!.data()!["unit"] as! String
                        let order = setDoc!.data()!["order"] as! Int
                        let duration = setDoc!.data()!["duration"] as! Int
                        let setOrder = setDoc!.data()!["setOrder"] as! Int
                        
                        let newSet = ExerciseSetStruct(repetition: rep, intensity: intensity, unit: unit, order: order, duration: duration, setOrder: setOrder)
                        
                        print("Exercise ID for this Set")
                        print(exerciseID)
                        var coreDataExercise: [Exercise] = []
                        let predicate = NSPredicate(format: "fbid == %@", exerciseID)
                        let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
                        fetchRequest.predicate = predicate
                        do {
                            try coreDataExercise = (self.coreDataController?.persistentContainer.viewContext.fetch(fetchRequest))!
                            print(coreDataExercise[0])
                            if setDataDict[coreDataExercise[0]] == nil {
                                setDataDict[coreDataExercise[0]] = []
                            }
                            setDataDict[coreDataExercise[0]]!.append(newSet)
                            print(setDataDict)
                            
                            callsLeft -= 1
                            if callsLeft == 0 {
                                let _ = self.coreDataController?.addWorkout(name: name, schedule: weekDateSchedule, setData: setDataDict, id: document.documentID)
                            }
                            
                        } catch {
                            print("Fetch Request failed")
                        }
                    }
                }
            }
        }
    }
    


    
    
    var coreDataController: CoreDataController?
    var firebaseController: FirebaseController?
    
    /*
     All follow methods are same as lab note, but they do for both firebase and coredata
     */
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
