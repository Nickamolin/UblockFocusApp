//
//  Profile.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/17/25.
//

import SwiftUI
import FirebaseAnalytics

struct Profile: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    private func deleteAccount() {
        Task {
            await viewModel.deleteAccount()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.authenticationState == .authenticated {
                    
                    Image(systemName: "person.circle")
                        .padding(.bottom, 5.0)
                        .font(.system(size: 100.0))
                    
                    Text("Signed in as user: \(viewModel.displayName)")
                    
                    Button {
                        viewModel.signOut()
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(.blue)
                    }
                    
                    Button {
                        deleteAccount()
                    } label: {
                        Text("Delete Account")
                    }
                    .buttonStyle(.borderedProminent)
                    .accentColor(.red)
                    
                    if !viewModel.errorMessage.isEmpty {
                        VStack {
                            Text(viewModel.errorMessage)
                                .foregroundStyle(.red)
                        }
                    }
                }
                else {
                    
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
        .environmentObject(AuthViewModel())
}
