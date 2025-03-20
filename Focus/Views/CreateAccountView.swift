//
//  CreateAccountView.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/20/25.
//

import SwiftUI

struct CreateAccountView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Text("Sign Up View")
            .font(.title)
            .padding(.bottom, 20.0)
        
        Button {
            viewModel.menuIsPresented = false
            viewModel.authenticationState = .authenticated
        } label: {
            Text("Create Account")
        }
        .buttonStyle(.borderedProminent)
        
        HStack {
            Text("Already have an account? ")
            Button {
                viewModel.currentMenuType = .login
            } label: {
                Text("Login")
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    CreateAccountView()
}
