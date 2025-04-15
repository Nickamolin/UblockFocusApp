//
//  DeviceActivityMonitorExtension.swift
//  ActivityMonitor
//
//  Created by Nicholas Gamolin on 4/10/25.
//

import DeviceActivity
import SwiftData
import _SwiftData_SwiftUI
import ManagedSettings

//extension ManagedSettingsStore.Name {
//    static let ublock = Self("ublock")
//}

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
//        guard let modelContainer = try? ModelContainer(for: Schedule.self) else { return }
//        let descriptor = FetchDescriptor<DistractingApps>()
//        let context = ModelContext(modelContainer)
//        let distractingApps = try? context.fetch(descriptor)
//        
//        let uBlockStore = ManagedSettingsStore(named: .ublock)
//        
//        if !distractingApps!.isEmpty {
//            uBlockStore.shield.applications = distractingApps?.first?.selectionTokens
//        }
        
        print("interval started!")
        
        // Handle the start of the interval.
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
//        let uBlockStore = ManagedSettingsStore(named: .ublock)
//        
//        uBlockStore.shield.applications = nil
        
        print("interval ended!")
        
        // Handle the end of the interval.
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
    
//    @MainActor
//    private func getScheduleData() -> [Schedule] {
//        guard let modelContainer = try? ModelContainer(for: Schedule.self) else {
//            return []
//        }
//        let descriptor = FetchDescriptor<Schedule>()
//        let schedules = try? modelContainer.mainContext.fetch(descriptor)
//        
//        return schedules ?? []
//    }
}
