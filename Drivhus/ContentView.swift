//
//  ContentView.swift
//  Drivhus
//
//  Created by Blu William Opland on 26/10/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var selection = 3
    
    var body: some View {
        
        
        TabView (selection: $selection) {
         
         
         Database()
         .tabItem {
         Image(systemName: "cylinder.split.1x2")
         Text("Database")
         }.tag(1)
         
         DatabaseControl()
         .tabItem {
         Image(systemName: "plus")
         Text("Add Sensor")
         }.tag(2)
         
         Home()
         .tabItem {
         Image(systemName: "house")
         Text("Home")
         }.tag(3)
         
         LoginView()
          .tabItem {
          Image(systemName: "person")
          Text("Account")
          }.tag(4)
          
         }
         .accentColor(Color(hex: 0xC36F48))  // Active tab color
    }
}
    


extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}


#Preview {
    ContentView()
}

