//
//  ProfileView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/22/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                avatarImage
                    .padding()
                settingsMenu
            }
            
            Button {
                viewModel.logout()
            } label: {
                Text("Logout")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
            }
            .background(Color.imperialRed)
            .cornerRadius(10.0)
            .padding()

//            NavigationLink(destination: LoginView(), isActive: $viewModel.isActive) { }
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
                                lineWidth: 8))
            .padding()
            
            Text(viewModel.profile?.userName ?? "")
                .font(Font.title2)
                .fontWeight(.semibold)
        }
    }
    
    private var settingsMenu: some View {
        VStack(alignment: .leading, spacing: 10) {
            GroupBox {
                SettingsMenuItemView(title: "Settings", image: nil, destination: SettingsView())
                Divider()
                SettingsMenuItemView(title: "About app", image: nil, destination: AboutView())
            }
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct SettingsMenuItemView<T: View>: View {
    var title: String
    var image: UIImage?
    var destination: T
    
    var body: some View {
        HStack {
            NavigationLink {
                destination
            } label: {
                HStack {
                    if image != nil, let image = image {
                        Image(uiImage: image)
                    }
                    Text(title)
                        .foregroundColor(.black)
                }
            }
            Spacer()
        }
    }
}
