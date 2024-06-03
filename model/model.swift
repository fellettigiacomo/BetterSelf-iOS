//
//  model.swift
//  gymui
//
//  Created by jack on 04/11/23.
//


import Foundation

struct Exercise {
    var name: String = ""
    var sets: Int = 0
    var reps: String = "0"
    var timeUnderTension: Int = 0
    var weight: Double = 0.0
    var machine: String = ""
    var rest: Int = 0
    var comment: String = ""
    var gifPath: String = ""
}

struct Section {
    var name: String = ""
    var muscleGroup: String = ""
    var exercises: [Exercise] = []
}

