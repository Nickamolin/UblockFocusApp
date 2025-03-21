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
    
    init() {
        registerAuthStateHandler()
    }
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? "(unknown)"
            }
        }
    }
    
    func resetInputs() {
        email = ""
        password = ""
        confirmPassword = ""
    }
}

extension AuthViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            user = authResult.user
            print("User \(authResult.user.uid) signed in")
            errorMessage = ""
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func createAccountWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        
        if (password != confirmPassword) {
            errorMessage = "Passwords do not match."
            return false
        }
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            user = authResult.user
            print("User \(authResult.user.uid) signed in")
            errorMessage = ""
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            errorMessage = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            errorMessage = ""
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
