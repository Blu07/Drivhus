//
//  UserAuthModel.swift
//  Drivhus
//
//  Created by Blu William Opland on 28/10/2024.
//

import SwiftUI
import GoogleSignIn

class UserAuthModel: ObservableObject {
    
    @Published var givenName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
    init() {
        check()
    }
    
    func checkStatus() {
        if let user = GIDSignIn.sharedInstance.currentUser {
            self.givenName = user.profile?.givenName ?? ""
            self.profilePicUrl = user.profile?.imageURL(withDimension: 100)?.absoluteString ?? ""
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
            self.givenName = "Not Logged In"
            self.profilePicUrl = ""
        }
    }
    
    func check() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let error = error {
                self?.errorMessage = "Error: \(error.localizedDescription)"
            }
            self?.checkStatus()
        }
    }
    
    func signIn() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController, hint: nil) { [weak self] user, error in
            if let error = error {
                self?.errorMessage = "Error: \(error.localizedDescription)"
                return
            }
            self?.checkStatus()
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}
