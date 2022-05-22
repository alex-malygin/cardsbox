//
//  LoginView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/25/21.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var settings: MainContentViewModel
    @ObservedObject var viewModel: OldLoginViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                circleBackground
                    .clipped()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    loginForm
                    Spacer()
                    registerButton
                }
                
                ActivityIndicator(shouldAnimate: $viewModel.showLoader)
            }
            .disabled(viewModel.showLoader)
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(title: Text("Error"), message: Text($viewModel.errorText.wrappedValue), dismissButton: .cancel())
            })
            .onAppear(perform: {
                updateNavigationAppearance(main: false)
            })
            .onChange(of: viewModel.isActive, perform: { newValue in
                withAnimation(.spring(response: 0.3)) {
                    settings.isLogin = newValue
                }
            })
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private var loginForm: some View {
        VStack(spacing: 3) {
            Text(Strings.loginTitle)
                .fontWeight(.semibold)
                .font(.title2)
                .padding([.top, .bottom], 20)
            
            
            TextFieldView(placeholder: Strings.placeholderEmail,
                          text: $viewModel.userModel.email.bound,
                          showButton: viewModel.isBiomericAvailable,
                          buttonImage: viewModel.emailIcon,
                          buttonAction: {
                viewModel.startBiomeric()
            })
                .keyboardType(.emailAddress)
                .padding([.top, .bottom], 5)
            
            
            SecureFieldView(placeholder: Strings.placeholderPassword,
                            text: $viewModel.userModel.password.bound)
                .keyboardType(.default)
                .padding([.top, .bottom], 5)
            
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                viewModel.login()
            } label: {
                Text(Strings.loginButton)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                    .background(Color.mainSkyBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8.0)
            }
            .padding()
        }
        .background(Color.formColor)
        .cornerRadius(25.0)
        .shadow(radius: 10)
        .padding([.leading, .trailing], 30)
    }
    
    private var registerButton: some View {
        VStack {
            Text(Strings.loginSubtitle)
                .fontWeight(.semibold)
            
            NavigationLink {
                LoginRouter.pushSignup()
            } label: {
                Text(Strings.registrationButton)
                    .fontWeight(.semibold)
                    .gradientForeground(colors: Gradients().flareCardBackground)
                    .cornerRadius(8.0)
            }
            .padding()
            
        }
        .padding()
    }
    
    private var circleBackground: some View {
        Circle()
            .fill(LinearGradient(gradient:
                                    Gradient(colors: Gradients().defaultCardBackground),
                                 startPoint: .bottom,
                                 endPoint: .top))
            .frame(width: UIScreen.screenWidth * 2,
                   height: UIScreen.screenWidth * 2,
                   alignment: .center)
            .position(x: UIScreen.screenWidth / 2,
                      y: 0)
    }
}
