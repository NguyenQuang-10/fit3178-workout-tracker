//
//  CoreDataController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 4/5/2023.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    var allExercisesFetchedResultsController: NSFetchedResultsController<Exercise>?
    var allWorkoutsFetchedResultsController: NSFetchedResultsController<Workout>?
    
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
                    listener.onWorkoutChange(change: .update, workoutExercise: fetchAllExercises())
                }
            }
        }
    }
    
    func addExerciseToWorkout(exercise: Exercise, workout: Workout) {
        workout.addToExercises(exercise)
    }
    
    func addWorkout(name: String, schedule: NSArray) -> Workout {
        let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: persistentContainer.viewContext) as! Workout
        workout.name = name
        workout.schedule = schedule
        
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
            listener.onWorkoutChange(change: .update, workoutExercise: fetchAllExercises())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addExercise(name: String, sets: NSArray) -> Exercise {
        let exercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: persistentContainer.viewContext) as! Exercise
        exercise.name = name
        exercise.sets = sets
        
        return exercise
    }
    
    func deleteExercise(exercise: Exercise) {
        persistentContainer.viewContext.delete(exercise)
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
            createDefaultExercises()
        }
    }
    
    func createDefaultExercises() {
        let _ = addExercise(name: "Bench Press", sets: [(8, 90)])
        let _ = addExercise(name: "Squats", sets: [(6, 100)])
        cleanup()
    }
    
    func createDefaultWorkout() {
        let _ = addWorkout(name: "Chest Day", schedule: [])
        cleanup()
    }
}
