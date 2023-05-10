//
//  FirebaseController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 10/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    
    let listeners = MulticastDelegate<DatabaseListener>()
    
    var authController: Auth
    var database: Firestore
    var exercissRef: CollectionReference?
    var workoutsRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        
        super.init()
        
        Task {
            do {
                let authDataResult = try await authController.signInAnonymously()
                currentUser = authDataResult.user
            } catch {
                fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
            }
            
//            self.setupExerciseListener()
            self.setupWorkoutListener()
        }
        
        
    }
    
    func cleanup() {
        return
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        //stuff needed to be add here, see CoreDataController
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addExercise(name: String, sets: [NSArray]) -> AnyObject {
        return Exercise()
    }
    
    func deleteExercise(exercise: Exercise) {
        return
    }
    
    func addWorkout(name: String, schedule: [WeekDates]) -> AnyObject {
        let workout = FirebaseWorkout()
        workout.name = name
        workout.schedule = schedule.map { $0.rawValue }
        if let workoutRef = workoutsRef?.addDocument(data: ["name" : name, "schedule" : schedule.map { $0.rawValue}]) {
            workout.id = workoutRef.documentID
        }
        return workout
    }
    
    func addExerciseToWorkout(exercise: Exercise, workout: Workout) {
        return
    }
    
    // MARK: - Firebase Controller Specific m=Methods
//    func setupExerciseListener()
    func setupWorkoutListener() {
        workoutsRef = database.collection("workouts")
    }
//    func getExerciseByID()
//    func getWorkoutByID()
//    func parseWorkoutSnapshot(snapshot: QuerySnapshot)
//    func parseExerciseSnapshot(snapshot: QueryDocumentSnapshot)
    

}
