//
//  Profile.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/17/25.
//

import SwiftUI
import FirebaseAnalytics

struct friendRequest: Identifiable {
    let id = UUID()
    var name: String
    var incoming: Bool
    var accepted: Bool
}

struct Profile: View {
    
    // auth
    @EnvironmentObject var viewModel: AuthViewModel
    
    private func deleteAccount() {
        Task {
            await viewModel.deleteAccount()
        }
    }
    
    // friend requests
    @State var userFriendRequests: [friendRequest] = [
        friendRequest(name: "Paul", incoming: true, accepted: false),
        friendRequest(name: "Duncan", incoming: true, accepted: false),
        friendRequest(name: "Leto", incoming: false, accepted: false),
    ]
    
    // view
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
                    
                    // friend requests:/
                    VStack {
                        Divider()
                        
                        Text("Friend Requests:")
                            .fontWeight(.bold)
                        
                        ScrollView {
                            // outgoing friend requests
                            VStack {
                                Text("Outgoing: ")
                                
                                
                                ForEach(userFriendRequests) { request in
                                    if request.incoming == false {
                                        friendRequestView(inputFriendRequest: request)
                                    }
                                }
                                
                            }
                            .padding(.top, 5.0)
                            
                            // incoming friend requests
                            VStack {
                                Text("Incoming: ")
                                
                                
                                ForEach(userFriendRequests) { request in
                                    if request.incoming == true {
                                        friendRequestView(inputFriendRequest: request)
                                    }
                                }
                                
                            }
                            .padding(.top, 5.0)
                        }
                    }
                    .padding(.top, 10.0)
                    
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    
                }
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image("lock2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        Text("Profile").font(.title).fontWeight(.bold)
                    }
                }
            }
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

struct friendRequestView: View {
    
    var inputFriendRequest: friendRequest
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "person.circle")
                    .font(.system(size: 20.0))
                Text(inputFriendRequest.name)
            }
            
            Spacer()
            
            HStack {
                if inputFriendRequest.incoming {
                    Button {
                        //implement
                    } label: {
                        Image(systemName: "person.fill.checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .accentColor(.green)
                    
                    Button {
                        //implement
                    } label: {
                        Image(systemName: "person.fill.xmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .accentColor(.red)
                }
                else {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                    Text("Pending")
                        .padding(.trailing, 9.0)
                }
            }
            .padding(.horizontal, 5.0)
            
        }
        .padding(.all, 5.0)
        .background(Rectangle()
            .foregroundColor(Color.gray.opacity(0.3))
            .cornerRadius(15))
        .padding(.bottom, 5.0)
    }
}

#Preview {
    Profile()
        .environmentObject(AuthViewModel())
}
