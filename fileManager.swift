//
//  fileManager.swift
//  gymui
//
//  Created by jack on 04/11/23.
//

import Foundation

class WorkoutParser: NSObject, XMLParserDelegate {
    var sections: [Section] = []
    var currentElement: String = ""
    var currentSection: Section?
    var currentExercise: Exercise?

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "section" {
            currentSection = Section()
        } else if currentElement == "exercise" {
            currentExercise = Exercise()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            switch currentElement {
            case "name":
                if currentExercise != nil {
                    currentExercise?.name = data
                } else {
                    currentSection?.name = data
                }
            case "muscleGroup": currentSection?.muscleGroup = data
            case "sets": currentExercise?.sets = Int(data) ?? 0
            case "reps": currentExercise?.reps = data
            case "timeUnderTension": currentExercise?.timeUnderTension = Int(data) ?? 0
            case "weight": currentExercise?.weight = Double(data) ?? 0.0
            case "machine": currentExercise?.machine = data
            case "rest": currentExercise?.rest = Int(data) ?? 0
            case "comment": currentExercise?.comment = data
            case "gifPath": currentExercise?.gifPath = data
            default: break
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "exercise" {
            currentSection?.exercises.append(currentExercise!)
            currentExercise = nil
        } else if elementName == "section" {
            sections.append(currentSection!)
            currentSection = nil
        }
    }
    
    func parseXML() -> [Section] {
        var sections: [Section] = []
        do {
            let path = Bundle.main.path(forResource: "workout", ofType: "xml")
            let url = URL(fileURLWithPath: path!)
            let data = try Data(contentsOf: url)
            let parser = XMLParser(data: data)
            let workoutParser = WorkoutParser()
            parser.delegate = workoutParser
            parser.parse()
            sections = workoutParser.sections
        } catch {
            print("\(error)")
        }
        return sections
    }
}
