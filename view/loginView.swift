//
//  loginView.swift
//  betterself
//
//  Created by jack on 02/06/24.
//

import SwiftUI

class Shared: ObservableObject {
    @Published var token: String?
}

enum NavigationTag: String, Hashable {
    case main
}

struct loginView: View {
    @EnvironmentObject var shared: Shared
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    private var apiEndpoint = "https://api.springmc.net/v1/login/"

    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 50)

                Text("Welcome back!")
                    .font(.largeTitle)
                    .padding()
                Text("BetterSelf - branch tpsit-project")

                Spacer()

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .frame(maxWidth: 350)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .frame(maxWidth: 350)

                Spacer()

                Button(action: {
                    login(username: username, password: password) { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let token):
                                // if login returns success, then change view and set token in the observable object
                                self.shared.token = token
                                print(shared.token!)
                                self.isAuthenticated = true

                            case .failure(let error):
                                self.alertMessage = error.localizedDescription
                                self.showingAlert = true
                            }
                        }
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Login Error"), message: Text(alertMessage),
                        dismissButton: .default(Text("OK")))
                }
                .padding()
                Spacer().frame(height: 50)
                
                // deprecated, i didn't got it working with the new substitutes.
                NavigationLink(destination: MainView(), isActive: $isAuthenticated) {
                    EmptyView()
                }
            }
        }
    }

    func login(
        username: String, password: String, completion: @escaping (Result<String, Error>) -> Void
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
            "username": username,
            "password": password,
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
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                }
                return
            }

            // check data
            guard let data = data else {
                completion(
                    .failure(
                        NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            // check for token's presence
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let token = json["token"] as? String
                {
                    completion(.success(token))
                } else {
                    completion(
                        .failure(
                            NSError(
                                domain: "", code: -1,
                                userInfo: [
                                    NSLocalizedDescriptionKey: "Authentication failure, check your credentials! (invalid response from server)"
                                ])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

#Preview {
    loginView().environmentObject(Shared())
}
