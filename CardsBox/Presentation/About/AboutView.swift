//
//  AboutView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/2/21.
//

import SwiftUI

struct AboutView: View {
    @State private var text = "CardsBox – an application that allows you to have enough of all bank card numbers in one place. \n\n No more need to save card numbers to notes or other places."
    
    var body: some View {
        ScrollView {
            VStack {
                Text(text)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
