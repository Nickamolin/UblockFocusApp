//
//  Home.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/17/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import FirebaseCore

struct Home: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    // Setting Restricted Apps
    @State var isPresented = false
    @State var selection = FamilyActivitySelection()
    @State var appsToBlock: [Application] = []
    
    let store = ManagedSettingsStore()
    let center = AuthorizationCenter.shared
    
    // On/Off Toggle Button
    @State var blockingStatus: Bool = false
    @State var blockingButtonText: String = "Off"
    @State var blockButtonColor: Color = .green
    
    var body: some View {
        
        NavigationStack {
            
            Spacer()
            
            VStack {
                
                Image("lock")
                    .resizable()
                    .padding(.bottom, 5.0)
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
                
                if viewModel.user != nil {
                    Text(viewModel.displayName)
                        .padding(.bottom, 30.0)
                }
                
                VStack {
                    
                    Button("Set Restricted Apps") {
                        isPresented = true
                    }
                    .familyActivityPicker(isPresented: $isPresented, selection: $selection)
                    .padding(.bottom, 5.0)
                    .buttonStyle(.bordered)
                    
                    Button("Set Goals") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                        //empty for now
                    }
                    .buttonStyle(.bordered)
                    .padding(.bottom, 5.0)
                    
                    
                    Button(blockingButtonText) {
                        toggleBlocking()
                    }
                    .buttonStyle(.borderedProminent)
                    .accentColor(blockButtonColor)
                    .padding(.bottom, 5.0)
                    
                }
            }
            .padding()
            .background(Rectangle()
                .foregroundColor(Color.gray.opacity(0.3))
                .cornerRadius(15))
            .padding()
            .navigationTitle(Text("Home"))
            
            Spacer()
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
    
    func toggleBlocking() {
        blockingStatus.toggle()
        
        if blockingStatus {
            blockingButtonText = "On"
            blockButtonColor = .red
            
            store.shield.applications = selection.applicationTokens
        }
        else {
            blockingButtonText = "Off"
            blockButtonColor = .green
            
            store.shield.applications = nil
        }
        
        print(blockingButtonText)
    }
}

#Preview {
    ContentView()
}
