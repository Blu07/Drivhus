//
//  Home.swift
//  Drivhus
//
//  Created by Blu William Opland on 27/10/2024.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color(hex: 0xFFFD87), location: 0.02),
                    .init(color: Color(hex: 0xcff6ff), location: 0.29),
                    .init(color: Color(hex: 0xa6cafd), location: 0.99)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Text("Drivhus").font(.system(size:54, weight: .heavy, design: .serif))
                Text("Welcome! This is the beginning of an amazing adventure. Hold tight!")
                    .padding()
            }
            
        }
    }
}

#Preview {
    Home()
}
