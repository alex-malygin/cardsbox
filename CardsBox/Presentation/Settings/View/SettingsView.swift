//
//  SettingsView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/2/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel(firestoreService: ServiceConfigurator.makeFirestoreService())
    @State var showSheet = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    avatarImage
                        .onTapGesture {
                            showSheet.toggle()
                        }
                    
                    TextFieldView(placeholder: "Username", text: $viewModel.profileInfo.userName.bound)
                    TextFieldView(placeholder: "Email", text: $viewModel.profileInfo.email.bound)
                        .disabled(true)
                        .onTapGesture {
                            viewModel.showDisabledAlert()
                        }
                    
                    Button {
                        viewModel.save()
                    } label: {
                        Text("SAVE")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                    }
                    .background(Color.imperialRed)
                    .cornerRadius(10.0)
                    .padding()
                }
            }
            
            ActivityIndicator(shouldAnimate: $viewModel.showLoader)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: { image in
                viewModel.setNewImage(image: image)
            })
        }
        .alert(isPresented: $viewModel.showAlert, content: {
            showAlert()
        })
    }
    
    private var avatarImage: some View {
        VStack {
            if viewModel.profileInfo.selectedImage == nil {
                WebImageView(imageURL: viewModel.profileInfo.url, placeholder: viewModel.image, lineWidth: 5)
                    .frame(width: 150, height: 150, alignment: .center)
            } else {
                AvatarView(image: viewModel.image)
                    .frame(width: 150, height: 150, alignment: .center)
            }
        }
    }
    
    private func showAlert() -> Alert {
        switch viewModel.alertType {
        case .error:
            return Alert(title: Text("Error"), message: Text(viewModel.errorText), dismissButton: .cancel())
        case .disableField:
            return Alert(title: Text("Sorry 🤷‍♂️"), message: Text(viewModel.errorText), dismissButton: .cancel())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
