//
//  LogoutButtonStyle.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/8/21.
//

import SwiftUI

struct LogoutButtonStyle: ButtonStyle {
    var text: String
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(text)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
        }
        .background(Color.imperialRed)
        .cornerRadius(10.0)
        .padding()
    }
}
