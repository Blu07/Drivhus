//
//  LoginView.swift
//  Drivhus
//
//  Created by Blu William Opland on 28/10/2024.
//

import SwiftUI

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var authModel: UserAuthModel
    
 
    var body: some View {
        
        VStack {
            if authModel.isLoggedIn {
                Text("Hi " + authModel.givenName + "!")
                Button(action: authModel.signOut) {
                    Text("Sign Out")
                }
            } else if !authModel.isLoggedIn {
                GoogleSignInButton(action: authModel.signIn)
                    .padding()
            } else {
                Text("Error when getting logged in status.")
            }
            
        }
    }
    
    
}
#Preview {
    LoginView()
}
