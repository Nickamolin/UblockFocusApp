//
//  LoginView.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/20/25.
//

import SwiftUI

private enum FocusedField: Hashable {
    case email
    case password
    case confirmPassord
}

struct LoginView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @FocusState private var focus: FocusedField?
    
    private func loginWithEmailPassword() {
        Task {
            if await viewModel.signInWithEmailPassword() == true {
                viewModel.menuIsPresented = false
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Login View")
                .font(.title)
                .padding(.bottom, 20.0)
            
            // Email Entry Field
            HStack {
                Image(systemName: "at")
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
            }
            .padding(.all, 5.0)
            .background(Divider(), alignment: .bottom)
            .padding(.all, 5.0)
            
            // Password Entry Field
            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $viewModel.password)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        loginWithEmailPassword()
                    }
            }
            .padding(.all, 5.0)
            .background(Divider(), alignment: .bottom)
            .padding(.all, 5.0)
            
            if !viewModel.errorMessage.isEmpty {
                VStack {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                }
            }
            
            
            Button {
                loginWithEmailPassword()
            } label: {
                Text("Login")
            }
            .padding(.all, 20.0)
            .buttonStyle(.borderedProminent)
            
            HStack {
                Text("Don't have an account? ")
                Button {
                    viewModel.currentMenuType = .createAccount
                    viewModel.errorMessage = ""
                    viewModel.resetInputs()
                } label: {
                    Text("Create Account")
                        .foregroundColor(.blue)
                }
            }
            
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
