//
//  Goal.swift
//  Focus
//
//  Created by Nicholas Gamolin on 4/7/25.
//

import SwiftUI
import SwiftData

@Model
class Goal: Identifiable {
    
    var id: String
    var name: String
    
    init(name: String) {
        
        self.id = UUID().uuidString
        self.name = name
    }
}
