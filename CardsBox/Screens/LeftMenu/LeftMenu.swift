//
//  LeftMenu.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/8/21.
//

import SwiftUI

struct LeftMenu: View {
    @ObservedObject var viewModel: LeftMenuViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            WebImageView(imageURL: viewModel.profile?.avatar, placeholder: viewModel.image)
            Text(viewModel.profile?.userName.bound ?? "")
                .font(Font.title2)
                .fontWeight(.semibold)
            
            List {
                SettingsMenuItemView(title: "Change profile", image: nil, destination: SettingsView())
                    .listRowBackground(Color.grayBackgroundView)
                SettingsMenuItemView(title: "About app", image: nil, destination: AboutView())
                    .listRowBackground(Color.grayBackgroundView)
            }
            .listStyle(.insetGrouped)
            
            Button {
                viewModel.logout()
            } label: { }
            .buttonStyle(LogoutButtonStyle(text: "Logout"))
            .padding(.bottom, 40)
        }
        .onAppear(perform: {
            viewModel.setUserProfile()
        })
        .border(width: 0.5, edges: [.trailing], color: .opaqueSeparator)
        .background(Color.systemBackground)
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct LeftMenu_Previews: PreviewProvider {
    static var previews: some View {
        LeftMenu(viewModel: LeftMenuViewModel())
    }
}

struct SettingsMenuItemView<T: View>: View {
    var title: String
    var image: UIImage?
    var destination: T
    
    var body: some View {
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
