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
                        .onTapGesture {
                            viewModel.showSheet = true
                        }
                    loginForm
                }
            }
            ActivityIndicator(shouldAnimate: $viewModel.showLoader)
        }
        .disabled(viewModel.showLoader)
        .sheet(isPresented: $viewModel.showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: { image in
                viewModel.setNewImage(image: image)
            })
        }
        .onAppear(perform: {
            updateNavigationAppearance(main: false)
        })
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorText),
                  dismissButton: .cancel())
        })
        .alert(isPresented: $viewModel.showBiometricalAlert, content: {
            Alert(title: Text(""),
                  message: Text(viewModel.errorText),
                  primaryButton: .cancel({
                viewModel.isActive = true
            }),
                  secondaryButton: .default(Text(Strings.actionOkTitle),
                                            action: {
                viewModel.saveUserData()
            }))
        })
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    var avatarImage: some View {
        VStack {
            AvatarView(image: viewModel.image)
        }
        .padding()
    }
    
    var loginForm: some View {
        VStack(spacing: 3) {
            Text("Create new account")
                .fontWeight(.semibold)
                .font(.title2)
                .padding([.top, .bottom], 20)
            
            TextFieldView(placeholder: "Username", text: $viewModel.userModel.userName.bound)
                .padding([.top, .bottom], 5)

            TextFieldView(placeholder: "Email", text: $viewModel.userModel.email.bound)
                .keyboardType(.emailAddress)
                .padding([.top, .bottom], 5)

            SecureFieldView(placeholder: "Password", text: $viewModel.userModel.password.bound)
                .keyboardType(.default)
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
            
            NavigationLink(destination: MainContainer(), isActive: $viewModel.isActive) { }
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
