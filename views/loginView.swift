//
//  loginView.swift
//  betterself
//
//  Created by jack on 02/06/24.
//

import SwiftUI

struct loginView: View {
    @State private var username: String = ""
        @State private var password: String = ""
        @State private var showingAlert = false
        @State private var alertMessage = ""
        @State private var token: String?
        private var apiEndpoint = "https://api.springmc.net/v1/login"
        
        var body: some View {
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
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Button(action: {
                            login(username: username, password: password) { (result) in
                                switch result {
                                case .success(let token):
                                    self.token = token
                                    // handle successful login, e.g., navigate to another view
                                case .failure(let error):
                                    self.alertMessage = error.localizedDescription
                                    self.showingAlert = true
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
                            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                        .padding()
                        
                        if let token = token {
                            Text("Token: \(token)")
                                .padding()
                        }
                        
                        Spacer().frame(height: 50)
                    }
                }
        
        func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
            guard let url = URL(string: apiEndpoint) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = ["username": username, "password": password]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(error))
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token = json["token"] as? String {
                        completion(.success(token))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }

#Preview {
    loginView()
}
