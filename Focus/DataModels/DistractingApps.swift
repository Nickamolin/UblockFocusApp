//
//  DistractingApps.swift
//  Focus
//
//  Created by Nicholas Gamolin on 4/9/25.
//

import SwiftUI
import SwiftData
import ManagedSettings

@Model
class DistractingApps: Identifiable {
    
    var id: String
    var selection: Set<ApplicationToken>
    
    init(selection: Set<ApplicationToken>) {
        
        self.id = UUID().uuidString
        self.selection = selection
    }
}
