//
//  Profile.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/17/25.
//

import SwiftUI
import FirebaseAnalytics

struct Profile: View {
    
    @StateObject private var viewModel = AuthViewModel()
    
    // View Toggling Controls
    enum menuType {
        case login
        case signup
    }
    
    enum authenticationStatus {
        case authenticated
        case unauthenticated
    }
    
    @State var authenticationStatus: authenticationStatus = .unauthenticated
    @State var menuType: menuType = .login
    
    @State var menuIsPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if self.authenticationStatus == .unauthenticated {
                    Image(systemName: "person.circle")
                        .padding(.bottom, 5.0)
                        .font(.system(size: 100.0))
                    Text("Not Logged In")
                    Button {
                        viewModel.menuIsPresented = true
                    } label: {
                        Text("Login")
                            .foregroundColor(.blue)
                    }
                    
                }
                else {
                    Image(systemName: "person.circle")
                        .padding(.bottom, 5.0)
                        .font(.system(size: 100.0))
                    Text("Signed in as user: [temp]")
                    Button {
                        self.authenticationStatus = .unauthenticated
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(.blue)
                    }
                }
                
            }
            .padding()
            .navigationTitle(Text("Profile"))
            .sheet(isPresented: $viewModel.menuIsPresented) {
                if viewModel.currentMenuType == .login {
                    
                    LoginView()
                        .environmentObject(viewModel)
                    
                }
                else {
                    
                    CreateAccountView()
                        .environmentObject(viewModel)
                    
                }
            }
        }
        
    }
}

#Preview {
    Profile()
}
