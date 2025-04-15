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
import DeviceActivity
import ManagedSettingsUI
//import FirebaseCore

// **********
extension DeviceActivityName {
    static let daily = Self("daily")
}

extension ManagedSettingsStore.Name {
    static let ublock = Self("ublock")
}

//class MyMonitor: DeviceActivityMonitor {
//    
//    @Environment(\.modelContext) private var context
//    
//    @Query var distractingApps: [DistractingApps]
//    
//    override func intervalDidStart(for activity: DeviceActivityName) {
//        super.intervalDidStart(for: activity)
//        
//        let uBlockStore = ManagedSettingsStore(named: .ublock)
//        
//        if !distractingApps.isEmpty {
//            uBlockStore.shield.applications = distractingApps.first?.selectionTokens
//        }
//        
//        print("interval started!")
//    }
//    
//    override func intervalDidEnd(for activity: DeviceActivityName) {
//        super.intervalDidEnd(for: activity)
//        
//        let uBlockStore = ManagedSettingsStore(named: .ublock)
//        
//        uBlockStore.shield.applications = nil
//        
//        print("interval ended!")
//    }
//}
// **********

struct Home: View {
    
    // for persistent local data
    @Environment(\.modelContext) private var context
    
    // for auth interactions
//    @EnvironmentObject var viewModel: AuthViewModel
    
    // Setting Restricted Apps
    //@State var isPickerPresented = false
//    @State var selection = FamilyActivitySelection()
//    @State var appsToBlock: [Application] = []
    
    @Query private var distractingApps: [DistractingApps]
    
    let store = ManagedSettingsStore()
    let authCenter = AuthorizationCenter.shared
    let activityCenter = DeviceActivityCenter()
    
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
    
    @Query private var schedules: [Schedule]
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                Image("lock2")
                    .resizable()
                    .frame(width: 200, height: 200)
                
                DistractingAppsBlock()
                    .modelContainer(for: [Goal.self, DistractingApps.self, Schedule.self])
                
                VStack {
                    HStack {
                        Text("Productive Alternatives")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("Edit") {
                            isGoalPickerPresented = true
                        }
                        .sheet(isPresented: $isGoalPickerPresented, onDismiss: {print("Dismissed")}, content: {
                            EditGoalsView(isPresented: $isGoalPickerPresented)
                                .modelContainer(for: [Goal.self, DistractingApps.self, Schedule.self])
                        })
                        .padding(.horizontal, 5.0)
                    }
                    
                    Divider()
                    
                    if goals.isEmpty {
                        Text("No Goals Set").opacity(0.3)
                    }
                    else {
                        ForEach(goals.sorted(by: { $0.listIndex < $1.listIndex })) { goal in
                            HStack {
                                Image(systemName: "circlebadge.fill")
                                Text(goal.name)
                                Spacer()
                            }.padding(.all, 2.0)
                        }
                    }
                }
                .padding()
                .background(Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .cornerRadius(15))
                .padding(.all , 5.0)
                
                VStack {
                    HStack {
                        Text("Schedule:")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveSchedule()
                        }
                        .padding(.horizontal, 5.0)
                    }
                    
                    Divider()
                    
                    // Time Controls
                    VStack {
                        
                        if !schedules.isEmpty {
                            // Time Controls
                            EditTimeControlsView(scheduleToEdit: schedules.first!)
                                .padding(.top, 5.0)
                        }
                        
//                        Button(blockingButtonText) {
//                            toggleBlocking()
//                        }
//                        .foregroundColor(.white)
//                        .padding(.all, 10.0)
//                        .background(Rectangle()
//                            .foregroundColor(blockButtonColor)
//                            .cornerRadius(7))
                    }
                    
                }
                .padding()
                .background(Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .cornerRadius(15))
                .padding(.all , 5.0)
            }
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    HStack {
//                        Image("lock2")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 50, height: 50)
//                        Text("Home").font(.title).fontWeight(.bold)
//                    }
//                }
//            }
            
        }
        .onAppear {
            
            if distractingApps.isEmpty {
                context.insert(DistractingApps(selectionTokens: Set<ApplicationToken>()))
                
                try? self.context.save()
            }
            
            if schedules.isEmpty {
                self.context.insert(Schedule(from: Date(), to: Date()))
                
                try? self.context.save()
            }
            
            Task {
                do {
                    try await authCenter.requestAuthorization(for: .individual)
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
            
            if !distractingApps.isEmpty {
                store.shield.applications = distractingApps.first?.selectionTokens
            }
        }
        else {
            blockingButtonText = "Off"
            blockButtonColor = .green
            
            store.shield.applications = nil
        }
        
        print(blockingButtonText)
    }
    
    func saveSchedule() {
        if !schedules.isEmpty {
            
            let testCenter = DeviceActivityCenter()
            let monitorSchedule = DeviceActivitySchedule(
                intervalStart: Calendar.current.dateComponents([.hour, .minute], from: schedules.first!.from),
                intervalEnd: Calendar.current.dateComponents([.hour, .minute], from: schedules.first!.to),
                repeats: true
            )
            
            do {
                try testCenter.startMonitoring(.daily, during: monitorSchedule)
            } catch {
                print("Unexpected error: \(error).")
            }
            
            print(Calendar.current.dateComponents([.hour, .minute], from: schedules.first!.from))
            
            print(Calendar.current.dateComponents([.hour, .minute], from: schedules.first!.to))
            
            print("saved schedule")
            
            guard let modelContainer = try? ModelContainer(for: Goal.self, DistractingApps.self, Schedule.self) else { return }
            let descriptor = FetchDescriptor<DistractingApps>()
            let context = ModelContext(modelContainer)
            let distractingApps = try? context.fetch(descriptor)
            
            print("for \(distractingApps?.first?.selectionTokens.count ?? 0) apps")
        }
    }
}

struct DistractingAppsBlock: View {
    @Environment(\.modelContext) private var context
    
    @Query private var distractingApps: [DistractingApps]
    
    @State var isPickerPresented = false
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Distracting Apps")
                    .font(.headline)
                
                Spacer()
                
                Button("Edit") {
                    isPickerPresented = true
                }
                .sheet(isPresented: $isPickerPresented, onDismiss: {print("Dismissed")}, content: {
                    EditDistractingAppsView(isPresented: $isPickerPresented)
                        .modelContainer(for: [Goal.self, DistractingApps.self, Schedule.self])
                })
                .padding(.horizontal, 5.0)
            }
            
            Divider()
            
            if !distractingApps.isEmpty {
                if distractingApps.first!.selectionTokens.isEmpty {
                    Text("No Apps Selected").opacity(0.3)
                }
                else {
                    ForEach(distractingApps.first!.selectionTokens.sorted(by: {$0.hashValue < $1.hashValue}), id: \.hashValue) { app in
                        HStack {
                            Label(app)
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding()
        .background(Rectangle()
            .foregroundColor(Color.gray.opacity(0.3))
            .cornerRadius(15))
        .padding(.all , 5.0)
        
    }
    
}

struct GoalsBlock: View {
    
    var body: some View {
        
    }
    
}

struct ScheduleBlock: View {
    
    var body: some View {
        
    }
    
}

struct EditDistractingAppsView: View {
    
    @Environment(\.modelContext) private var context
    @Binding var isPresented: Bool
    @Query private var distractingApps: [DistractingApps]
    
    @State var selection = FamilyActivitySelection()
    
    var body: some View {
        NavigationStack {
            FamilyActivityPicker(selection: $selection)
            .navigationTitle(Text("Choose Apps"))
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
                        
                        if distractingApps.isEmpty {
                            context.insert(DistractingApps(selectionTokens: selection.applicationTokens))
                            
                            try? self.context.save()
                        }
                        else {
                            distractingApps.first?.selectionTokens = selection.applicationTokens
                            //distractingApps.first?.selectionApps = selection.applications
                            
                            try? self.context.save()
                        }
                        
                        
                        isPresented = false
                    }
                    .foregroundColor(.blue)
                    .font(.headline)
                }
            }
        }
        .onAppear {
            if !distractingApps.isEmpty {
                selection.applicationTokens = distractingApps.first!.selectionTokens
                
            }
        }
    }
}

struct EditGoalsView: View {
    
    @Environment(\.modelContext) private var context
    @Binding var isPresented: Bool
    @Query private var goals: [Goal]
    
    var body: some View {
        NavigationStack {
            VStack {
                
                List {
                    ForEach(goals.sorted(by: { $0.listIndex < $1.listIndex })) { goal in
                        EditGoalCell(goalToEdit: goal)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            
                            context.delete(goals.sorted(by: { $0.listIndex < $1.listIndex })[index])
                            
                        }
                    }
                    if goals.count < 15 {
                        HStack {
                            Spacer()
                            Button("[+]") {
                                
                                context.insert(Goal(name: "", listIndex: goals.count))
                                
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
                        for goal in goals {
                            if goal.name.isEmpty {
                                self.context.delete(goal)
                            }
                        }
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

struct EditTimeControlsView: View {
    
    @Bindable var scheduleToEdit: Schedule
    
    var body: some View {
        HStack {
            DatePicker(
                "From: ",
                selection: $scheduleToEdit.from,
                displayedComponents: .hourAndMinute
            )
        }
        HStack {
            DatePicker(
                "To: ",
                selection: $scheduleToEdit.to,
                displayedComponents: .hourAndMinute
            )
        }
    }
}

//struct DateControls: View {
//    
//    var body: some View {
//        
//        HStack {
//            
//            Image(systemName: "s.circle")
//                .font(.system(size: 20.0))
//            Image(systemName: "m.circle.fill")
//                .font(.system(size: 20.0))
//                .foregroundColor(.blue)
//            Image(systemName: "t.circle.fill")
//                .font(.system(size: 20.0))
//                .foregroundColor(.blue)
//            Image(systemName: "w.circle.fill")
//                .font(.system(size: 20.0))
//                .foregroundColor(.blue)
//            Image(systemName: "t.circle")
//                .font(.system(size: 20.0))
//            Image(systemName: "f.circle.fill")
//                .font(.system(size: 20.0))
//                .foregroundColor(.blue)
//            Image(systemName: "s.circle")
//                .font(.system(size: 20.0))
//            
//        }
//        .padding(.all, 10.0)
//        
//    }
//}

#Preview {
    ContentView()
}
