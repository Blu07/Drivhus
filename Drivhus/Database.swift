//
//  Database.swift
//  Drivhus
//
//  Created by Blu William Opland on 27/10/2024.
//

import SwiftUI

struct Database: View {
    @State private var sensors = [Sensors]()
    @State private var types = [SensorTypes]()
    
  
    
    var body: some View {
        
        VStack {
            
            // Sensors List
            ScrollView {
                VStack {
                    Text("Registered sensors")
                        .padding(.top)
                        .bold()
                    ForEach(sensors, id: \.sensorID) { item in
                        Text("ID: \(item.sensorID), Name: \(item.name)")
                    }
                    
                    Text("Known Sensor Types")
                        .padding(.top)
                        .bold()
                    ForEach(types, id: \.type) { item in
                        Text("Type: \(item.type), Name: \(item.description)")
                    }
                }
            }
            .onAppear {
                fetchData(for: "get_sensors", username: "Blu", password: "BluErKul", model: [Sensors].self) { result in
                    if let sensors = result {
                        self.sensors = sensors
                    }
                }
                
                fetchData(for: "get_sensor_types", username: "Blu", password: "BluErKul", model: [SensorTypes].self) { result in
                    if let types = result {
                        self.types = types
                    }
                }
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


struct APICall: Codable {
    var call: String
    var payload: SensorPayload?
    var username: String
    var password: String
}

struct SensorPayload: Codable {
    var type: String
    var description: String
    var error_value: String
}

struct PayloadResponse: Codable {
    var message: String?
    var error: String?
}

struct Sensors: Codable {
    var sensorID: String
    var type: String
    var name: String
    var stat: String
    var description: String
}

struct SensorTypes: Codable {
    var type: String
    var description: String
    var error_value: String?
}

#Preview {
    Database()
}
