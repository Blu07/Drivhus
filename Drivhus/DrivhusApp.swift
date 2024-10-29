//
//  DrivhusApp.swift
//  Drivhus
//
//  Created by Blu William Opland on 26/10/2024.
//
//
// https://developers.google.com/identity/sign-in/ios/sign-in#using-swiftui

import SwiftUI
import SwiftData

import GoogleSignIn
import GoogleSignInSwift

@main
struct DrivhusApp: App {
    
    @StateObject private var authModel = UserAuthModel() // Initialize UserAuthModel

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel) // Provide UserAuthModel to the environment
        }
    }
}



