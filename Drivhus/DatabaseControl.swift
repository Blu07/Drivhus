//
//  DatabaseControl.swift
//  Drivhus
//
//  Created by Blu William Opland on 27/10/2024.
//

import SwiftUI

struct DatabaseControl: View {
    
    @State private var type: String = ""
    @State private var description: String = ""
    @State private var error_value: String = ""
    
    var body: some View {
        
        
        VStack {
            Text("Add a new sensor")
                .bold()
            TextField("Type", text: $type)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Error Value", text: $error_value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                
                let payload = SensorPayload(type: type, description: description, error_value: error_value)
                
                fetchData(
                    for: "add_sensor",
                    payload: payload,
                    username: "Blu",
                    password: "BluErKul",
                    model: PayloadResponse.self) { response in
                        if let response = response {
                            print("Repsonse: ", response)
                        }
                    }
            }) {
                Text("Upload Data")
            }
        }
    }
    
    
    func fetchData<T: Decodable>(for call: String, payload: Encodable? = nil, username: String, password: String, model: T.Type, completion: @escaping (T?) -> Void) {
        guard let url = URL(string: "https://bluwo.me/api.php") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var fullRequestDict: [String: Any] = [
            "call": call,
            "username": username,
            "password": password
        ]
        
        // Encode payload only if it's provided
        if let payload = payload {
            let encoder = JSONEncoder()
            do {
                // Encode payload
                let payloadData = try encoder.encode(payload)
                
                // Convert the payload data to a JSON dictionary
                if let payloadDict = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] {
                    fullRequestDict["payload"] = payloadDict
                }
            } catch {
                print("Encoding error: \(error)")
                completion(nil)
                return
            }
        }
        
        // Convert the full request dictionary to JSON data
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: fullRequestDict, options: [])
            request.httpBody = requestBody
        } catch {
            print("Failed to encode request body: \(error)")
            completion(nil)
            return
        }
        
        // Call the API and handle the results or errors.
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Check if response is an HTTPURLResponse and check the status code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Server returned error \(httpResponse.statusCode):")
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print(errorMessage)
                }
                completion(nil)
                return
            }
        
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(model, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse)
                }
            } catch {
                print("Decoding error: \(error) with model \(model.self)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON data: \(jsonString)")
                }
                completion(nil)
            }
        }.resume()
        
    }
}

#Preview {
    DatabaseControl()
}
