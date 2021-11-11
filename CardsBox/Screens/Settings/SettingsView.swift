//
//  SettingsView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/2/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
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
            Alert(title: Text("Error"), message: Text($viewModel.errorText.wrappedValue), dismissButton: .cancel())
        })
    }
    
    private var avatarImage: some View {
        VStack {
            if viewModel.profileInfo.selectedImage == nil {
                WebImageView(imageURL: viewModel.profileInfo.url, placeholder: viewModel.image)
            } else {
                AvatarView(image: viewModel.image)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
