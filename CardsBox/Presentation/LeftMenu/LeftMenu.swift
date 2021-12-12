//
//  LeftMenu.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/8/21.
//

import SwiftUI

struct LeftMenu: View {
    @EnvironmentObject var settings: MainContentViewModel
    @ObservedObject var viewModel: LeftMenuViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                WebImageView(imageURL: viewModel.profile?.avatar, placeholder: viewModel.image, lineWidth: 8)
                    .frame(width: 150, height: 150, alignment: .center)
                Text(viewModel.profile?.userName ?? "")
                    .font(Font.title2)
                    .fontWeight(.semibold)
                
                List {
                    SettingsMenuItemView(title: Strings.leftMenuChangeProfile, image: nil, destination: SettingsView())
                        .listRowBackground(Color.grayBackgroundView)
                    SettingsMenuItemView(title: Strings.leftMenuAboutApp, image: nil, destination: AboutView())
                        .listRowBackground(Color.grayBackgroundView)
                }
                .listStyle(.insetGrouped)
                
                Button {
                    viewModel.logout()
                    settings.isLogin = false
                } label: { }
                .buttonStyle(LogoutButtonStyle(text: Strings.logoutButton))
                .padding(.bottom, 40)
            }
            .onAppear(perform: {
                viewModel.setUserProfile()
            })
            .padding(.top, 40)
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .navigationViewStyle(.stack)
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

//struct LeftMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        LeftMenu(viewModel: LeftMenuViewModel())
//    }
//}
