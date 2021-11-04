//
//  TextFieldView.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 15.06.2021.
//

import SwiftUI
import Combine

struct TextFieldView: View {
    @Binding var text: String
    @State var maxLenth: Int
    private var placeholder: String
    
    init(_ placeholder: String, text: Binding<String>, maxLenth: Int = 50) {
        self.placeholder = placeholder
        self._text = text
        self.maxLenth = maxLenth
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
        TextFieldView("Enter name", text: .constant("132213123213"))
    }
}
