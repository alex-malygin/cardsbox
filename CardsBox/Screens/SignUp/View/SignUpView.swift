//
//  SignUpView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/26/21.
//

import SwiftUI

struct SignUpView: View {
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
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
        }
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    var avatarImage: some View {
        VStack {
            Image("avatar")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .clipShape(Circle())
                .shadow(radius: 8)
                .overlay(Circle()
                            .stroke(LinearGradient(gradient:
                                                    Gradient(colors: Gradients().defaultCardBackground),
                                                   startPoint: .bottomLeading,
                                                   endPoint: .topTrailing),
                                    lineWidth: 8))
                .padding()
        }
    }
    
    var loginForm: some View {
        VStack(spacing: 3) {
            Text("Login account")
                .fontWeight(.semibold)
                .font(.title2)
                .padding([.top, .bottom], 20)
            
            TextFieldView("Username", text: $userName)
                .onChange(of: userName, perform: { newValue in
                    viewModel.userModel.userName = newValue
                })
                .keyboardType(.emailAddress)
                .padding([.top, .bottom], 5)

            TextFieldView("Email", text: $email)
                .onChange(of: email, perform: { newValue in
                    viewModel.userModel.email = newValue
                })
                .keyboardType(.emailAddress)
                .padding([.top, .bottom], 5)

            TextFieldView("Password", text: $password)
                .onChange(of: password, perform: { newValue in
                    viewModel.userModel.password = newValue
                })
                .keyboardType(.emailAddress)
                .padding([.top, .bottom], 5)
            
            Button {
                viewModel.registration()
            } label: {
                Text("Register")
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
