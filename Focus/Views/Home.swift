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
    
    //Time Selection
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    var body: some View {
        
        NavigationStack {
            
            Spacer()
            
            VStack {
                
                Image("lock2")
                    .resizable()
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
                    .foregroundColor(.white)
                    .familyActivityPicker(isPresented: $isPresented, selection: $selection)
                    .padding(.all, 5.0)
                    .frame(width: 200, height: 30)
                    .background(Rectangle()
                        .foregroundColor(Color.gray.opacity(0.3))
                        .cornerRadius(7))
                    
                    Button("Set Goals") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                        //empty for now
                    }
                    .foregroundColor(.white)
                    .padding(.all, 5.0)
                    .frame(width: 200, height: 30)
                    .background(Rectangle()
                        .foregroundColor(Color.gray.opacity(0.3))
                        .cornerRadius(7))
                    
                    
                    Button(blockingButtonText) {
                        toggleBlocking()
                    }
                    .foregroundColor(.white)
                    .padding(.all, 5.0)
                    .frame(width: 200, height: 30)
                    .background(Rectangle()
                        .foregroundColor(blockButtonColor)
                        .cornerRadius(7))
                    
                }
                .padding(.all, 10.0)
                
                VStack {
                    
                    Text("Schedule:")
                        .font(.headline)
                    
                    DateControls()
                    
                    // Time Controls
                    VStack {
                        
                        // Time Controls
                        HStack {
                            DatePicker(
                                "From: ",
                                selection: $startTime,
                                displayedComponents: .hourAndMinute
                            )
                            .frame(width: 200.0, height: 30.0)
                            .padding(.all, 5.0)
                        }
                        HStack {
                            DatePicker(
                                "To: ",
                                selection: $endTime,
                                displayedComponents: .hourAndMinute
                            )
                            .frame(width: 200.0, height: 30.0)
                            .padding(.all, 5.0)
                        }
                    }
                    .padding(.all, 10.0)
                    
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

struct DateControls: View {
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "s.circle")
                .font(.system(size: 20.0))
            Image(systemName: "m.circle.fill")
                .font(.system(size: 20.0))
                .foregroundColor(.blue)
            Image(systemName: "t.circle.fill")
                .font(.system(size: 20.0))
                .foregroundColor(.blue)
            Image(systemName: "w.circle.fill")
                .font(.system(size: 20.0))
                .foregroundColor(.blue)
            Image(systemName: "t.circle")
                .font(.system(size: 20.0))
            Image(systemName: "f.circle.fill")
                .font(.system(size: 20.0))
                .foregroundColor(.blue)
            Image(systemName: "s.circle")
                .font(.system(size: 20.0))
            
        }
        .padding(.all, 10.0)
        
    }
}

#Preview {
    ContentView()
}
