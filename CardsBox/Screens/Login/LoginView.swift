//
//  LoginView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/25/21.
//

import SwiftUI

struct LoginView: View {
    @State var userName: String = ""
    @State var auth: Bool = false
    
    var body: some View {
        ZStack {
            circleBackground
            
            VStack {
                Spacer()
                loginForm
                Spacer()
                registerButton
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var loginForm: some View {
        VStack(spacing: 3) {
            Text("Login account")
                .fontWeight(.semibold)
                .font(.title2)
                .padding([.top, .bottom], 20)
            
            TextFieldView("Email", text: $userName)
                .keyboardType(.emailAddress)
                .padding([.top, .bottom], 5)
            
            TextFieldView("Password", text: $userName)
                .keyboardType(.emailAddress)
                .padding([.top, .bottom], 5)
            
            NavigationLink(destination: MainTabView()) {
                Text("Login")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                    .background(Color.mainSkyBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8.0)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(25.0)
        .shadow(radius: 10)
        .padding([.leading, .trailing], 30)
    }
    
    private var registerButton: some View {
        VStack {
            Text("Don't have an account?")
                .fontWeight(.semibold)
            
            NavigationLink(destination: SignUpView()) {
                Text("Register")
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
                      y: -50)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
