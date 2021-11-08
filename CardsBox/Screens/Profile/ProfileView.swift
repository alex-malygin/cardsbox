//
//  ProfileView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/22/21.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            List {
                Section {
                    avatarImage
                }
                .listRowBackground(Color.clear)
                
                Section {
                    SettingsMenuItemView(title: "Settings", image: nil, destination: SettingsView())
                    SettingsMenuItemView(title: "About app", image: nil, destination: AboutView())
                }
            }
            .listStyle(.insetGrouped)
            
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
        }
        .onAppear(perform: {
            viewModel.setUserProfile()
        })
        .background(Color.mainGrayColor)
    }
    
    private var avatarImage: some View {
        HStack {
            Spacer()
            VStack {
                WebImageView(imageURL: viewModel.profile?.avatar, placeholder: viewModel.image)
                
                Text(viewModel.profile?.userName ?? "")
                    .font(Font.title2)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
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
                        .foregroundColor(.label)
                }
            }
        }
    }
}
