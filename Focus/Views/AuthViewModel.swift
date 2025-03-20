//
//  AuthViewModel.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/20/25.
//

import SwiftUI
import FirebaseAuth

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationMenuType {
    case login
    case createAccount
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var currentMenuType: AuthenticationMenuType = .login
    @Published var menuIsPresented: Bool = false
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    @Published var errorMessage = ""
    @Published var user: User?
    
    @Published var displayName = ""
}

extension AuthViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        
        authenticationState = .authenticated
        return true
    }
    
    func createAccountWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        
        authenticationState = .authenticated
        return true
    }
    
    func signOut() {
        authenticationState = .unauthenticated
    }
    
    func deleteAccount() async -> Bool {
        authenticationState = .unauthenticated
        return true
    }
}
