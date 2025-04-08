//
//  FocusApp.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/2/25.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
    // for local emulation
    //Auth.auth().useEmulator(withHost: "localhost", port: 9099)
      
    return true
  }
}

@main
struct FocusApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Goal.self)
    }
}
