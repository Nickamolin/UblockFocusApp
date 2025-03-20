//
//  Leaderboard.swift
//  Focus
//
//  Created by Nicholas Gamolin on 3/17/25.
//

import SwiftUI

struct friend: Identifiable {
    let id = UUID()
    var name: String
    var screenTime: Int
}

struct Leaderboard: View {
    
    @State var friends: [friend] = [
        friend(name: "Paul", screenTime: 3),
        friend(name: "Duncan", screenTime: 5),
        friend(name: "Leto", screenTime: 7)
    ]
    
    var body: some View {
//        ScrollView {
//            
//        }
        NavigationStack {
            
            VStack {
                
                ForEach(friends) { person in
                    friendView(inputFriend: person)
                }
                
                
                Spacer()
            }
            .padding()
            .navigationTitle(Text("Leaderboard"))
        }
    }
}

struct friendView: View {
    
    var inputFriend: friend
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "person.circle")
                    .font(.system(size: 70.0))
                Text(inputFriend.name)
            }
            
            Spacer()
            
            VStack {
                Text(String(inputFriend.screenTime) + "h")
                    .font(.system(size: 65.0, weight: .bold))
                Text("Screen Time")
            }
        }
        .padding()
        .background(Rectangle()
            .foregroundColor(Color.gray.opacity(0.3))
            .cornerRadius(15))
        .padding(.bottom, 5.0)
    }
}

#Preview {
    Leaderboard()
}
