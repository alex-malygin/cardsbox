//
//  TextFieldView.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 15.06.2021.
//

import SwiftUI
import Combine

struct TextFieldView: View {
    var placeholder: String
    @Binding var text: String
    @State var maxLenth: Int = 50
    var showButton = false
    var buttonImage: UIImage?
    var buttonAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField(placeholder, text: $text)
                    .frame(height: 45)
                    .textFieldStyle(PlainTextFieldStyle())
                    .cornerRadius(16)
                    .padding([.horizontal], 24)
                    .onReceive(Just(self.text)) { inputValue in
                        if inputValue.count > maxLenth {
                            self.text.removeLast()
                        }
                    }
                if showButton {
                    Button {
                        buttonAction?()
                    } label: {
                        Image(uiImage: buttonImage ?? UIImage())
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .padding([.trailing], 20)
                    }
                }
            }
            Rectangle()
                .frame(height: 2)
                .padding(.horizontal, 24)
                .foregroundColor(.gray)
                .opacity(0.2)
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(placeholder: "Enter name", text: .constant("132213123213"))
    }
}
