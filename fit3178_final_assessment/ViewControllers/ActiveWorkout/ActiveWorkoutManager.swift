//
//  ActiveWorkoutManager.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 7/6/2023.
//

import Foundation

class ActiveWorkoutManager {
    
    var delegate: ActiveWorkoutDelegate?
    var exerciseSets: Dictionary<Exercise, [ExerciseSet]>?
    var workout: Workout?
    var exerciseArray: [Exercise] = []
    
    func loadWorkoutData(workout: Workout, exerciseSets: Dictionary<Exercise, [ExerciseSet]>){
        self.exerciseSets = exerciseSets
        self.workout = workout
        exerciseArray = Array(exerciseSets.keys)
    }
    
    var timer: Timer?
    
    func startWorkout() {
        exerciseIndex = 0
        currentExercise = exerciseArray[exerciseIndex!]
        
        setIndex = 0
        currentSets = exerciseSets![exerciseArray[exerciseIndex!]]
        minuteLeft = 2 // replace with set time after implementing
        delegate?.updateMinute(min: minuteLeft!)
        secondLeft = 0
        delegate?.updateSecond(sec: secondLeft!)
        delegate?.updateSet(setData: currentSets![setIndex!], num: setIndex! + 1, total: currentSets!.count)
        delegate?.updateExercise(exercise: currentExercise!)
        
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workoutSubroutine), userInfo: nil, repeats: true)
    }
    
    var minuteLeft: Int?
    var secondLeft: Int?
    var currentExercise: Exercise?
    var currentSets: [ExerciseSet]?
    var setIndex: Int?
    var exerciseIndex: Int?
    
    @objc
    func workoutSubroutine() {
        if secondLeft! > 0 {
            secondLeft! -= 1
            delegate?.updateSecond(sec: secondLeft!)
        } else if minuteLeft! > 0 {
            minuteLeft! -= 1
            secondLeft! = 59
            delegate?.updateMinute(min: minuteLeft!)
            delegate?.updateSecond(sec: secondLeft!)
        } else if setIndex! < currentSets!.count - 1 {
            setIndex! += 1
            // reset time for new set
            minuteLeft = 2
            delegate?.updateSecond(sec: secondLeft!)
            secondLeft = 0
            delegate?.updateMinute(min: minuteLeft!)
            
            // update set for delegate
            delegate?.updateSet(setData: currentSets![setIndex!], num: setIndex! + 1, total: currentSets!.count)
        } else if exerciseIndex! < exerciseArray.count - 1{
            exerciseIndex! += 1
            setIndex = 0
            currentExercise = exerciseArray[exerciseIndex!]
            currentSets = exerciseSets![currentExercise!]
            
            delegate?.updateExercise(exercise: currentExercise!)
            delegate?.updateSet(setData: currentSets![setIndex!], num: setIndex! + 1, total: currentSets!.count)
            
            minuteLeft = 2
            delegate?.updateSecond(sec: secondLeft!)
            secondLeft = 0
            delegate?.updateMinute(min: minuteLeft!)
            
        } else {
            timer?.invalidate()
            print("Finished workout")
        }
        
    }
    
    func finishWorkout() {
        timer?.invalidate()
        delegate?.finishWorkout()
    }
    
    
}
