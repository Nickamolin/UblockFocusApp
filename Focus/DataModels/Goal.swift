//
//  Goal.swift
//  Focus
//
//  Created by Nicholas Gamolin on 4/7/25.
//

import SwiftUI
import SwiftData
import ManagedSettings

@Model
class Goal: Identifiable {
    
    var id: String
    var name: String
    var listIndex: Int
    
    init(name: String, listIndex: Int) {
        
        self.id = UUID().uuidString
        self.name = name
        self.listIndex = listIndex
    }
}
