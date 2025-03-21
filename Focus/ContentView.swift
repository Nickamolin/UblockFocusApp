//
//  ContentView.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/2/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import FirebaseCore

struct ContentView: View {
    
    // needed for access to screen time api
    let center = AuthorizationCenter.shared
    
    // for tab titles
    enum Tabs: String {
        case leaderboard
        case home
        case profile
    }
    
    // for account auth
    @StateObject private var viewModel = AuthViewModel()
    
    @State var selectedTab: Tabs = .home
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            Leaderboard()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Leaderboard")
                }
                .tag(Tabs.leaderboard)
            Home()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(Tabs.home)
            Profile()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(Tabs.profile)
        }
        .onAppear {
            Task {
                do {
                    try await center.requestAuthorization(for: .individual)
                } catch {
                    print("Failed to enroll with error: \(error)")
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
