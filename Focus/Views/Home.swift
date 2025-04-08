//
//  Home.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/17/25.
//

import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings
import FirebaseCore

struct Home: View {
    
    // for persistent local data
    @Environment(\.modelContext) private var context
    
    // for auth interactions
    @EnvironmentObject var viewModel: AuthViewModel
    
    // Setting Restricted Apps
    @State var isPickerPresented = false
    @State var selection = FamilyActivitySelection()
    @State var appsToBlock: [Application] = []
    
    let store = ManagedSettingsStore()
    let center = AuthorizationCenter.shared
    
    // On/Off Toggle Button
    @State var blockingStatus: Bool = false
    @State var blockingButtonText: String = "Off"
    @State var blockButtonColor: Color = .green
    
    // Setting Goals
    @State var isGoalPickerPresented = false
    
    @Query private var goals: [Goal]
    
    //Time Selection
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
//                Image("lock2")
//                    .resizable()
//                    .frame(width: 200, height: 200)
//                    .aspectRatio(contentMode: .fit)
                
                if viewModel.user != nil {
                    Text("Logged in as \(viewModel.displayName)")
                        .padding(.bottom, 30.0)
                }
                
                VStack {
                    Divider()
                    HStack {
                        Text("Distracting Apps")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("Edit") {
                            isPickerPresented = true
                        }
                        .familyActivityPicker(isPresented: $isPickerPresented, selection: $selection)
                        .padding(.all, 5.0)
                    }
                    
                    if selection.applications.isEmpty {
                        Text("No Apps Selected").opacity(0.3)
                    }
                    else {
                        ForEach(selection.applications.sorted(by: {$0.localizedDisplayName ?? "" < $1.localizedDisplayName ?? ""}), id: \.hashValue) { app in
                            Text(app.bundleIdentifier ?? "")
                        }
                    }
                    
                    Divider()
                    HStack {
                        Text("Productive Alternatives")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("Edit") {
                            isGoalPickerPresented = true
                        }
                        .sheet(isPresented: $isGoalPickerPresented, onDismiss: {print("Dismissed")}, content: {
                            EditGoalsView(isPresented: $isGoalPickerPresented)
                                .modelContainer(for: Goal.self)
                        })
                        .padding(.all, 5.0)
                    }
                    
                    if goals.isEmpty {
                        Text("No Goals Set").opacity(0.3)
                    }
                    else {
                        ForEach(goals) { goal in
                            Text(goal.name)
                        }
                    }
                    
                }
                .padding(.all, 10.0)
                
                VStack {
                    
                    Divider()
                    
                    HStack {
                        
                        Text("Schedule:")
                            .font(.headline)
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 10.0)
                    
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
                    
                }
            }
            .padding()
            .background(Rectangle()
                .foregroundColor(Color.gray.opacity(0.3))
                .cornerRadius(15))
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image("lock2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        Text("Home").font(.title).fontWeight(.bold)
                    }
                }
            }
            
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

struct EditGoalsView: View {
    
    @Environment(\.modelContext) private var context
    @Binding var isPresented: Bool
    @Query private var goals: [Goal]
    
    @State var goalsToDelete: [Goal] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                
                List {
                    ForEach(goals) { goal in
                        EditGoalCell(goalToEdit: goal)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(goals[index])
                        }
                    }
                    if goals.count < 5 {
                        HStack {
                            Spacer()
                            Button("[+]") {
                                
                                context.insert(Goal(name: ""))
                                
                                try? self.context.save()
                            }
                            Spacer()
                        }
                        
                    }
                }
            }
            .navigationTitle(Text("Edit Goals"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.blue)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        try? self.context.save()
                        isPresented = false
                    }
                    .foregroundColor(.blue)
                    .font(.headline)
                }
            }
        }
    }
}

struct EditGoalCell: View {
    
    @Bindable var goalToEdit: Goal
    
    var body: some View {
        TextField("Enter Goal", text: $goalToEdit.name)
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
