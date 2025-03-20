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
        
        if (password != confirmPassword) {
            errorMessage = "Passwords do not match."
            authenticationState = .unauthenticated
            return false
        }
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            user = authResult.user
            print("User \(authResult.user.uid) signed in")
            authenticationState = .authenticated
            displayName = user?.email ?? "(unknown)"
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signOut() {
        authenticationState = .unauthenticated
    }
    
    func deleteAccount() async -> Bool {
        authenticationState = .unauthenticated
        return true
    }
}
