//
//  Workout.swift
//  Which Weight?
//
//  Created by Joe on 9/7/21.
//

import Foundation

struct Exercise: Hashable
{
    var name: String
    
    init(_ name: String)
    {
        self.name = name
    }
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool
    {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Exercise, rhs: Exercise) -> Bool
    {
        return lhs.name < rhs.name
    }
}

class Workout
{
    var exercises: [Exercise]
    init(_ exercises: [Exercise])
    {
        self.exercises = exercises
    }
    
    func addExercise(_ newExercise: Exercise)
    {
        exercises.append(newExercise)
    }
    
    func removeExercise(_ exerciseToRemove: String)
    {
        exercises.removeAll(where: {$0.name == exerciseToRemove})
    }
}

class WorkoutLog
{
    var exercisesDone: [Exercise:String] = [:]
    var date: Date
    
    init(workout: Workout, weightsDone: [String], date: Date)
    {
        // TODO later: check they're both the same length
        for i in 0..<workout.exercises.count
        {
            exercisesDone[workout.exercises[i]] = weightsDone[i]
        }
        
        self.date = date
    }
}
