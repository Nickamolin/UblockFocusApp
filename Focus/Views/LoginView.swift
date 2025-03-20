//
//  LoginView.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/20/25.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        Text("Login View")
            .font(.title)
            .padding(.bottom, 20.0)
        
        Button {
            viewModel.menuIsPresented = false
            viewModel.authenticationState = .authenticated
        } label: {
            Text("Login")
        }
        .buttonStyle(.borderedProminent)
        
        HStack {
            Text("Don't have an account? ")
            Button {
                viewModel.currentMenuType = .createAccount
            } label: {
                Text("Sign Up")
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    LoginView()
}
