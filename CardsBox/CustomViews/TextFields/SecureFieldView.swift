//
//  SecureFieldView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/11/21.
//

import SwiftUI

struct SecureFieldView: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                SecureField(placeholder, text: $text)
                    .frame(height: 45)
                    .textFieldStyle(PlainTextFieldStyle())
                    .cornerRadius(16)
                    .padding([.horizontal], 24)
            }
            Rectangle()
                .frame(height: 2)
                .padding(.horizontal, 24)
                .foregroundColor(.gray)
                .opacity(0.2)
        }
    }
}

struct SecureTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SecureFieldView(placeholder: "Password", text: .constant("123456"))
    }
}
