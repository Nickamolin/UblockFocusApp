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
    var selectionTokens: Set<ApplicationToken>
    //var selectionApps: Set<Application>
    
    init(selectionTokens: Set<ApplicationToken>) {
        
        self.id = UUID().uuidString
        self.selectionTokens = selectionTokens
        //self.selectionApps = selectionApps
    }
}
