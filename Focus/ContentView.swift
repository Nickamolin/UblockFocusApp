//
//  ContentView.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/2/25.
//

import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings
//import FirebaseCore

struct ContentView: View {
    
    // for persistent local data
    @Environment(\.modelContext) private var context
    
    @Query var distractingApps: [DistractingApps]
    @Query var schedules: [Schedule]
    
    // needed for access to screen time api
    let center = AuthorizationCenter.shared
    
    // for tab titles
    enum Tabs: String {
        case leaderboard
        case home
        case profile
    }
    
    // for account auth
//    @StateObject private var viewModel = AuthViewModel()
    
//    @State var selectedTab: Tabs = .home
    
    var body: some View {
        
//        TabView(selection: $selectedTab) {
//            Leaderboard()
//                .environmentObject(viewModel)
//                .tabItem {
//                    Image(systemName: "trophy.fill")
//                    Text("Leaderboard")
//                }
//                .tag(Tabs.leaderboard)
//            Home()
//                .environmentObject(viewModel)
//                .modelContainer(for: Goal.self)
//                .tabItem {
//                    Image(systemName: "house.fill")
//                    Text("Home")
//                }
//                .tag(Tabs.home)
//            Profile()
//                .environmentObject(viewModel)
//                .tabItem {
//                    Image(systemName: "person.circle")
//                    Text("Profile")
//                }
//                .tag(Tabs.profile)
//        }
        Home()
            .modelContainer(for: [Goal.self, DistractingApps.self, Schedule.self])
        .onAppear {
            
            if distractingApps.isEmpty {
                self.context.insert(DistractingApps(selectionTokens: Set<ApplicationToken>()))
                
                try? self.context.save()
            }
            
            if schedules.isEmpty {
                self.context.insert(Schedule(from: Date(), to: Date()))
                
                try? self.context.save()
            }
            
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
