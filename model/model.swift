//
//  model.swift
//  gymui
//
//  Created by jack on 04/11/23.
//


import Foundation

struct Exercise: Codable {
  let id: Int
  let name: String
  let sets: Int
  let reps: String
  let timeUnderTension: Int
  let weight: Double
  let machine: String
  let rest: Int
  let comment: String?
}

struct Section: Codable {
  let id: Int
  let name: String
  let muscleGroup: String
  let exercises: [Exercise]
}

struct WorkoutData: Codable {
  let sections: [Section]
  let id: Int
}


