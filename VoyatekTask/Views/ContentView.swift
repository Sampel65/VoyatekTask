//
//  ContentView.swift
//  VoyatekTask
//
//  Created by Samson Oluwapelumi on 20/02/2025.
//

import SwiftUI

struct ContentView: View {
    // Add state for selected tab
    @State private var selectedTab = 0
    
    var body: some View {
        // Replace VStack with TabView
        TabView(selection: $selectedTab) {
            // Home tab
            FoodListView()
                .tabItem {
                    Image( "home")
                    Text("Home")
                }
                .tag(0)
            
            // Generator tab
            Text("Generator View")
                .tabItem {
                    Image( "magicpen")
                    Text("Generator")
                }
                .tag(1)
            
            // Add tab
            AddFoodView()
                .tabItem {
                    Image( "PlusCircle")
                    Text("Add")
                }
                .tag(2)
            
            // Favourite tab
            Text("Favourites View")
                .tabItem {
                    Image("heart")
                    Text("Favourite")
                }
                .tag(3)
            
            // Planner tab
            Text("Planner View")
                .tabItem {
                    Image( "calendar")
                    Text("Planner")
                }
                .tag(4)
        }
        .tint(.blue) // Set the tint color for selected tab
    }
}

#Preview {
    ContentView()
}
