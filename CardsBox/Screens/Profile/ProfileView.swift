//
//  ProfileView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/22/21.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        VStack {
            ScrollView {
                avatarImage
                    .padding()
                
                settingsMenu
            }
            
            NavigationLink(destination: MainContentView(auth: false)) {
                Text("Logout")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
            }
            .frame(width: 300, height: 50, alignment: .center)
            .background(Color.imperialRed)
            .cornerRadius(10.0)
            .padding()
        }
    }
    
    private var avatarImage: some View {
        VStack {
            Image("avatar")
                .resizable()
            .frame(width: 150, height: 150, alignment: .center)
            .clipShape(Circle())
            .shadow(radius: 8)
            .overlay(Circle()
                        .stroke(LinearGradient(gradient:
                                                Gradient(colors: Gradients().defaultCardBackground),
                                               startPoint: .bottom,
                                               endPoint: .top),
                                lineWidth: 7))
            .padding()
            
            Text("Alexander Malygin")
                .font(Font.title2)
                .fontWeight(.semibold)
        }
    }
    
    private var settingsMenu: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationLink {
                SignUpView()
            } label: {
                Label("About app", systemImage: "iphone")
            }
            Divider()
            
            NavigationLink {
                
            } label: {
                Label("About app", systemImage: "iphone")
            }
            Divider()
            
            NavigationLink {
                
            } label: {
                Label("About app", systemImage: "iphone")
            }
            
        }
        .padding()
        .background(.white)
        .overlay(RoundedRectangle(cornerRadius: 10.0)
                    .stroke(.clear))
        .cornerRadius(10.0)
        .padding()
        .shadow(color: .secondary ,radius: 5)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
