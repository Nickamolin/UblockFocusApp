//
//  Schedule.swift
//  Focus
//
//  Created by Nicholas Gamolin on 4/10/25.
//

import SwiftUI
import SwiftData
import ManagedSettings

@Model
class Schedule: Identifiable {
    
    var id: String
    var from: Date
    var to: Date
    
    init(from: Date, to: Date) {
        
        self.id = UUID().uuidString
        self.from = from
        self.to = to
    }
}
