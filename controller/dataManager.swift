//  betterself
//
//  Created by jack on 03/06/24.
//
//
//  dataManager.swift

import Foundation
import Network

// consts
let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
let filePath = documentsDirectory.appendingPathComponent("workout.json")
let apiEndpoint = "https://api.springmc.net/v1/workouts/"
let isOnline = true

// check if device is online
func checkOnline() {

}

// use API to download latest data
func getWorkoutData(token: String, completion: @escaping (Result<[Section], Error>) -> Void) {
  // Create request
  guard let url = URL(string: apiEndpoint) else {
    fatalError("Invalid URL")
  }

  var request = URLRequest(url: url)
  request.httpMethod = "GET"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")

  // Add auth data
  request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

  // Create session
  let session = URLSession.shared
  let task = session.dataTask(with: request) { data, response, error in
    if let error = error {
      completion(.failure(error))
      return
    }

    guard let httpResponse = response as? HTTPURLResponse,
      (200..<300).contains(httpResponse.statusCode)
    else {
      completion(
        .failure(
          NSError(
            domain: "NetworkError", code: -1, userInfo: ["message": "Invalid response from server"])
        ))
      return
    }

    guard let data = data else {
      completion(
        .failure(NSError(domain: "NetworkError", code: -1, userInfo: ["message": "No data"])))
      return
    }

    // at this point, exercises are stored in "data", they will now be stored on the device and then the parsing will proceed.
    do {
      // use UTF-8 encoding
      let jsonString = String(data: data, encoding: .utf8)
      guard let jsonData = jsonString?.data(using: .utf8) else {
        throw NSError(
          domain: "EncodingError", code: -2,
          userInfo: ["message": "Failed to convert data to UTF-8 string"])
      }

      // write to file
      try jsonData.write(to: filePath)
      print("file saved")
    } catch {
      print("error saving file:" + error.localizedDescription)
      completion(.failure(error))
    }

    // parse data
    do {
      let workoutData = try JSONDecoder().decode([WorkoutData].self, from: data)
      print("JSON Parsing complete: \(workoutData)")
      completion(.success(workoutData[0].sections))
      return
    } catch {
      print("Error while parsing JSON: \(error)")
      completion(.failure(error))
    }
    print(filePath)

    if !isOnline {
      // read file (use if device is offline)
      do {
        let jsonData = try Data(contentsOf: filePath)
        let workoutData = try JSONDecoder().decode([WorkoutData].self, from: jsonData)
        completion(.success(workoutData[0].sections))
        return
      } catch {
        print("Errore while parsing JSON: \(error)")
      }
    }
  }
  task.resume()
}
