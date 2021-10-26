//
//  SignUpView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/26/21.
//

import SwiftUI

struct SignUpView: View {

    var body: some View {
        NavigationLink(destination: MainTabView()) {
            Text("Register")
                .fontWeight(.semibold)
                .gradientForeground(colors: Gradients().flareCardBackground)
                .cornerRadius(8.0)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
