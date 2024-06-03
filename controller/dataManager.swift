//
//  dataManager.swift
//  betterself
//
//  Created by jack on 03/06/24.
//

import Foundation

let filePath = "/data/workout.json"
private var apiEndpoint = "http://api.springmc.net/v1/workouts"

func saveJSONToFile(json: [String: Any]) {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            try jsonString.write(toFile: filePath, atomically: true, encoding: .utf8)
        }
    } catch {
        print("Error saving JSON to file: \(error)")
    }
}

func getWorkout(
    token: String, completion: @escaping (Result<String, Error>) -> Void
  ) {
    // create request
    guard let url = URL(string: apiEndpoint) else {
      fatalError("url not found")
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // parameters
    let parameters: [String: Any] = [
      "token": token,
    ]

    // JSON serialization
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
      request.httpBody = jsonData
    } catch {
      print("Error serialising JSON: \(error.localizedDescription)")
    }

    // create session
    let session = URLSession.shared
    let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in

      // check response
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode)
      else {
        print("Invalid response from server")
        return
      }

      // check data
      URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
          completion(.failure(error))
          return
        }

        guard let data = data else {
          completion(
            .failure(
              NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
          return
        }

        print(data)
      }.resume()
    }
    task.resume()
  }
