//
//  CreateAccountView.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/20/25.
//

import SwiftUI
import FirebaseAnalytics

private enum FocusedField: Hashable {
    case email
    case password
    case confirmPassword
}

struct CreateAccountView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @FocusState private var focus: FocusedField?
    
    private func createAccountWithEmailPassword() {
        Task {
            if await viewModel.createAccountWithEmailPassword() == true {
                viewModel.menuIsPresented = false
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Create Account View")
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
                        self.focus = .confirmPassword
                    }
            }
            .padding(.all, 5.0)
            .background(Divider(), alignment: .bottom)
            .padding(.all, 5.0)
            
            // Confirm Password Entry Field
            HStack {
                Image(systemName: "lock")
                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .focused($focus, equals: .email)
                    .submitLabel(.go)
                    .onSubmit {
                        createAccountWithEmailPassword()
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
                createAccountWithEmailPassword()
            } label: {
                Text("Create Account")
            }
            .padding(.all, 20.0)
            .buttonStyle(.borderedProminent)
            
            HStack {
                Text("Already have an account? ")
                Button {
                    viewModel.currentMenuType = .login
                    viewModel.errorMessage = ""
                    viewModel.resetInputs()
                } label: {
                    Text("Login")
                        .foregroundColor(.blue)
                }
            }
            
        }
        .padding(.horizontal, 10.0)
    }
}

#Preview {
    CreateAccountView()
        .environmentObject(AuthViewModel())
}
