import Foundation

class WorkoutParser {
    var sections: [Section] = []
    
    // parse the JSON file
    func parseJSON(jsonData: Data) -> [Section]? {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            if let sectionsArray = json as? [[String: Any]] {
                for sectionDict in sectionsArray {
                    if let section = parseSection(sectionDict: sectionDict) {
                        sections.append(section)
                    }
                }
                return sections
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        return nil
    }
    
    // parse a single section
    private func parseSection(sectionDict: [String: Any]) -> Section? {
        guard let name = sectionDict["name"] as? String,
              let muscleGroup = sectionDict["muscleGroup"] as? String,
              let exercisesArray = sectionDict["exercises"] as? [[String: Any]] else {
            return nil
        }
        
        var exercises: [Exercise] = []
        for exerciseDict in exercisesArray {
            if let exercise = parseExercise(exerciseDict: exerciseDict) {
                exercises.append(exercise)
            }
        }
        
        return Section(name: name, muscleGroup: muscleGroup, exercises: exercises)
    }
    
    // parse a single exercise
    private func parseExercise(exerciseDict: [String: Any]) -> Exercise? {
        guard let name = exerciseDict["name"] as? String,
              let sets = exerciseDict["sets"] as? Int,
              let reps = exerciseDict["reps"] as? String,
              let timeUnderTension = exerciseDict["timeUnderTension"] as? Int,
              let weight = exerciseDict["weight"] as? Double,
              let machine = exerciseDict["machine"] as? String,
              let rest = exerciseDict["rest"] as? Int,
              let comment = exerciseDict["comment"] as? String,
              let gifPath = exerciseDict["gifPath"] as? String else {
            return nil
        }
        
        return Exercise(name: name, sets: sets, reps: reps, timeUnderTension: timeUnderTension, weight: weight, machine: machine, rest: rest, comment: comment, gifPath: gifPath)
    }
}
