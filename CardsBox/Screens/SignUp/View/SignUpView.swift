//
//  SignUpView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/26/21.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
            circleBackground
                .clipped()
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    avatarImage
                        .padding()
                    loginForm
                }
            }
            ActivityIndicator(shouldAnimate: $viewModel.showLoader)
        }
        .sheet(isPresented: $viewModel.showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: { image in
                viewModel.setNewImage(image: image)
            })
        }
        .onAppear(perform: {
            updateNavigationAppearance(main: false)
        })
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text("Error"), message: Text($viewModel.errorText.wrappedValue), dismissButton: .cancel())
        })
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    var avatarImage: some View {
        VStack {
            Image(uiImage: $viewModel.image.wrappedValue)
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .cornerRadius(70)
                .clipShape(Circle())
                .shadow(radius: 8)
                .overlay(Circle()
                            .stroke(LinearGradient(gradient:
                                                    Gradient(colors: Gradients().defaultCardBackground),
                                                   startPoint: .bottomLeading,
                                                   endPoint: .topTrailing),
                                    lineWidth: 8))
                .padding()
                .onTapGesture {
                    viewModel.showSheet = true
                }
        }
    }
    
    var loginForm: some View {
        VStack(spacing: 3) {
            Text("Create new account")
                .fontWeight(.semibold)
                .font(.title2)
                .padding([.top, .bottom], 20)
            
            TextFieldView("Username", text: $viewModel.userModel.userName.bound)
                .padding([.top, .bottom], 5)

            TextFieldView("Email", text: $viewModel.userModel.email.bound)
                .keyboardType(.emailAddress)
                .padding([.top, .bottom], 5)

            TextFieldView("Password", text: $viewModel.userModel.password.bound)
                .keyboardType(.emailAddress)
                .padding([.top, .bottom], 5)
            
            Button {
                viewModel.registration()
            } label: {
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                    .background(Color.mainSkyBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8.0)
            }
            .padding()
            
            NavigationLink(destination: MainTabView(), isActive: $viewModel.isActive) { }
        }
        .background(Color.formColor)
        .cornerRadius(25.0)
        .shadow(radius: 10)
        .padding([.leading, .trailing], 30)
    }
    
    private var circleBackground: some View {
        Circle()
            .fill(LinearGradient(gradient:
                                    Gradient(colors: Gradients().defaultCardBackground),
                                 startPoint: .top,
                                 endPoint: .bottom))
            .frame(width: UIScreen.screenWidth * 2,
                   height: UIScreen.screenWidth * 2,
                   alignment: .center)
            .position(x: UIScreen.screenWidth / 2,
                      y: 0)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
