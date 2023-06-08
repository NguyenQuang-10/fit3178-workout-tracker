//
//  CoreDataController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 4/5/2023.
//

import UIKit
import CoreData



class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate, RecordingDataController {
    
    func addExerciseSet(rep: Int, intensity: Int, unit: String, exerciseID: String, workoutID: String, order: Int, duration: Int, setOrder: Int) -> AnyObject {
        return FirebaseExerciseSet()
    }
    
    func clearAllData() {
        let fetchExerciseRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Exercise")
        let deleteExerciseRequest = NSBatchDeleteRequest(fetchRequest: fetchExerciseRequest)
        
        let fetchExerciseSetRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ExerciseSet")
        let deleteExerciseSetRequest = NSBatchDeleteRequest(fetchRequest: fetchExerciseSetRequest)
        
        let fetchWorkoutRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Workout")
        let deleteWorkoutRequest = NSBatchDeleteRequest(fetchRequest: fetchWorkoutRequest)
        
        let fetchRecordingRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "WorkoutRecording")
        let deleteRecordingRequest = NSBatchDeleteRequest(fetchRequest: fetchRecordingRequest)


        do {
            try persistentContainer.viewContext.execute(deleteExerciseSetRequest)
            try persistentContainer.viewContext.save()
            
            try persistentContainer.viewContext.execute(deleteExerciseRequest)
            try persistentContainer.viewContext.save()
            
            try persistentContainer.viewContext.execute(deleteWorkoutRequest)
            try persistentContainer.viewContext.save()
            
            try persistentContainer.viewContext.execute(deleteRecordingRequest)
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func syncWithOnline() {
        
    }

    
    
    
    var allExercisesFetchedResultsController: NSFetchedResultsController<Exercise>?
    var allWorkoutsFetchedResultsController: NSFetchedResultsController<Workout>?
    var allRecordingFetchedResultsController: NSFetchedResultsController<WorkoutRecording>?
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allExercisesFetchedResultsController {
            listeners.invoke() {
                listener in
                if listener.listenerType == .exercise || listener.listenerType == .all {
                    
                    listener.onAllExercisesChange(change: .update, exercises: fetchAllExercises())
                }
            }
        } else if controller == allWorkoutsFetchedResultsController {
            listeners.invoke() { (listener) in
                if listener.listenerType == .workout || listener.listenerType == .all {
                    listener.onWorkoutChange(change: .update, workoutExercise: fetchAllWorkouts())
                }
            }
        }
    }
    
    
    func addWorkout(name: String, schedule: [WeekDates], setData: Dictionary<Exercise, [ExerciseSetStruct]>, id: String) -> AnyObject {
        let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: persistentContainer.viewContext) as! Workout
        workout.name = name
        workout.fbid = id
        var newSchedule = [Int]()
        for date in schedule {
            newSchedule.append(date.rawValue)
        }
        for (e, setStructs ) in setData {
            print("\(e.name) count of set: \(setStructs.count)")
            for s in setStructs {
                print("\(s.unit)")
                print("\(e.name)")
                let exerciseSet = NSEntityDescription.insertNewObject(forEntityName: "ExerciseSet", into: persistentContainer.viewContext) as! ExerciseSet
                exerciseSet.workout = workout
                exerciseSet.exercise = e
                print("\(exerciseSet.exercise?.name)")
                exerciseSet.repetition = Int16(s.repetition)
                exerciseSet.intensity = Int16(s.intensity)
                exerciseSet.unit = s.unit
                exerciseSet.order = Int16(s.order)
                exerciseSet.duration = Int16(s.duration)
                exerciseSet.setOrder = Int16(s.setOrder)
                workout.addToExercises(exerciseSet)
            }
        }
        workout.schedule = newSchedule
        
        return workout
    }
    
    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .exercise || listener.listenerType == .all {
            listener.onAllExercisesChange(change: .update, exercises: fetchAllExercises())
        }
        
        if listener.listenerType == .workout || listener.listenerType == .all {
            listener.onWorkoutChange(change: .update, workoutExercise: fetchAllWorkouts())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addExercise(name: String, desc: String, imageURL: String, id: String) -> AnyObject {
        let exercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: persistentContainer.viewContext) as! Exercise
        exercise.name = name
        exercise.desc = desc
        exercise.imageURL = imageURL
        exercise.fbid = id
        
        return exercise
    }
    
    
    
    func deleteExercise(exercise: Exercise) {
        persistentContainer.viewContext.delete(exercise)
    }
    
    func addExerciseSetToWorkout(exercise: Exercise, workout: Workout, repetition: Int, intensity: Int, unit: String) {
    }
    
    func fetchAllExercises() -> [Exercise] {
        if allExercisesFetchedResultsController == nil {
            let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            allExercisesFetchedResultsController = NSFetchedResultsController<Exercise>(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            allExercisesFetchedResultsController?.delegate = self
        }
        
        do {
            try allExercisesFetchedResultsController?.performFetch()
        } catch {
            print("Fetch request failed: \(error)")
        }
        
        if let exercises = allExercisesFetchedResultsController?.fetchedObjects {
            return exercises
        }
        
        return [Exercise]()
    }
    
    func fetchAllWorkouts() -> [Workout] {
        if allWorkoutsFetchedResultsController == nil {
            let request: NSFetchRequest<Workout> = Workout.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            allWorkoutsFetchedResultsController = NSFetchedResultsController<Workout>(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            allWorkoutsFetchedResultsController?.delegate = self
        }
        
        do {
            try allWorkoutsFetchedResultsController?.performFetch()
        } catch {
            print("Fetch request failed: \(error)")
        }
        
        if let workouts = allWorkoutsFetchedResultsController?.fetchedObjects {
            return workouts
        }
        
        return [Workout]()
    }
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores(completionHandler: { (description, error) in
                if let error = error {
                    fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        })
        super.init()
        if fetchAllWorkouts().count == 0 {
            createDefaultWorkout()
        }
        if fetchAllExercises().count == 0 {
            createDefaultExercise()
        }
//        let _ = addWorkout(name: "Back Day", schedule: [])
//        cleanup()
    }
    
    func addNewAudioRecord(title: String, uuid: String) {
        let rec = NSEntityDescription.insertNewObject(forEntityName: "WorkoutRecording", into: persistentContainer.viewContext) as! WorkoutRecording
        rec.uuid = uuid
        rec.title = title
        
        cleanup()
    }
    
    func getAllRecordingInfo() -> [WorkoutRecording]{
        if allRecordingFetchedResultsController == nil {
            let request: NSFetchRequest<WorkoutRecording> = WorkoutRecording.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            allRecordingFetchedResultsController = NSFetchedResultsController<WorkoutRecording>(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            allRecordingFetchedResultsController?.delegate = self
        }
        
        do {
            try allRecordingFetchedResultsController?.performFetch()
        } catch {
            print("Fetch request failed: \(error)")
        }
        
        if let recordings = allRecordingFetchedResultsController?.fetchedObjects {
            return recordings
        }
        
        return [WorkoutRecording]()
    }
    

    func createDefaultWorkout() {
        let _ = addWorkout(name: "Chest Day", schedule: [], setData: [:], id: "testDefaultWorkout")
        
    }
    
    func createDefaultExercise() {
        let _ = addExercise(name: "Bench press", desc: "Lay flat on a bench and press a barbell over your chest", imageURL: "", id: "testDefault")
    }
}
