//
//  FirebaseController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 10/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol, FirebaseAuthenticationDelegate {
    func clearAllData() {
        
    }
    
    func syncWithOnline() {
        
    }
    
    func addExerciseSet(rep: Int, intensity: Int, unit: String, exerciseID: String, workoutID: String) -> AnyObject {
        var exerciseSet = FirebaseExerciseSet()
        exerciseSet.repetition = Int16(rep)
        exerciseSet.intensity = Int16(intensity)
        exerciseSet.unit = unit
        exerciseSet.exercise = exerciseID
        exerciseSet.workout = workoutID


        do {
            if let exerciseSetRef = try exerciseSetRef?.addDocument(from: exerciseSet) {
                exerciseSet.id = exerciseSetRef.documentID
            }
        } catch {
            print("Failed to serialize exercisee")
        }

        return exerciseSet
    }
    
    
    
    
    let listeners = MulticastDelegate<DatabaseListener>()
    
    var authController: Auth
    var database: Firestore
    var exercissRef: CollectionReference?
    var workoutsRef: CollectionReference?
    var exerciseSetRef: CollectionReference?
    var userRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
        
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()

        
        super.init()
        
        if authController.currentUser != nil{
            do {
              try authController.signOut()
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
        }
        
//        Task {
//            do {
//                let authDataResult = try await authController.signInAnonymously()
//                currentUser = authDataResult.user
//            } catch {
//                fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
//            }
//            
////            self.setupExerciseListener()
//            self.setupWorkoutListener()
//        }
        
        
    }
    
    func login(email: String, password: String) async throws {
        let authResult = try await authController.signIn(withEmail: email, password: password)
        currentUser = authResult.user
        
        if let _ = currentUser {
            userRef = database.collection("user")
            self.setupWorkoutListener()
//            print(currentUser!.uid as String)
        }

    }
    
    func signup(email: String, password: String) async throws {
        let authResult = try await authController.createUser(withEmail: email, password: password)
        currentUser = authResult.user
        

        if let _ = currentUser {
            userRef = database.collection("user")
            
            let _ = userRef?.document(currentUser!.uid).setData(["user-id": currentUser!.uid]) {
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            self.setupWorkoutListener()
            print(currentUser!.uid as String)
        }
    }
    
    func signinAnonmously() async throws {
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
    
    func addExercise(name: String, desc: String, imageURL: String, id: String) -> AnyObject {
        let exercise = FirebaseExercise()
        exercise.name = name
        exercise.desc = desc
        exercise.imageURL = imageURL
        
        
        do {
            if (try exercissRef?.document(id).setData(from: exercise)) != nil {
                print("Successfully serialize exercise")
            }
        } catch {
            print("Failed to serialize exercisee")
        }
        
        return exercise
    }
    
    
    func deleteExercise(exercise: Exercise) {
        return
    }
    
    func addWorkout(name: String, schedule: [WeekDates], setData: Dictionary<Exercise, [ExerciseSetStruct]>, id: String) -> AnyObject {
        let workout = FirebaseWorkout()
        workout.name = name
        workout.schedule = schedule.map { $0.rawValue }
        
        for (e, setStructs ) in setData {
            for s in setStructs {
                let newSet = addExerciseSet(rep: s.repetition, intensity: s.intensity, unit: s.unit, exerciseID: e.fbid!, workoutID: id) as! FirebaseExerciseSet
                workout.exercises.append(newSet.id!)
            }
        }
        
        do {
            if (try workoutsRef?.document(id).setData(from: workout)) != nil {
                print("Successful serializing workout")
            }
            return workout
        } catch {
            print("Fail serializing workout")
        }
        
        return workout
    }
    
    func addExerciseSetToWorkout(exercise: Exercise, workout: Workout, repetition: Int, intensity: Int, unit: String) {
        
    }
    

    
    // MARK: - Firebase Controller Specific m=Methods
    func setupExerciseListener() {
//        setupWorkoutListener()
        exerciseSetRef = userRef?.document(currentUser!.uid).collection("exercisesSets")
        exercissRef = userRef?.document(currentUser!.uid).collection("exercises")
    }
    func setupWorkoutListener() {
        setupExerciseListener()
        workoutsRef = userRef?.document(currentUser!.uid).collection("workouts")
    }
//    func getExerciseByID()
//    func getWorkoutByID()
//    func parseWorkoutSnapshot(snapshot: QuerySnapshot)
//    func parseExerciseSnapshot(snapshot: QueryDocumentSnapshot)
    

    

}
