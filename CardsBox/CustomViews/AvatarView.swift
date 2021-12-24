//
//  AvatarView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/6/21.
//

import SwiftUI

struct AvatarView: View {
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .cornerRadius(70)
            .scaledToFill()
            .clipped()
            .clipShape(Circle())
            .shadow(radius: 8)
            .overlay(Circle()
                        .stroke(LinearGradient(gradient:
                                                Gradient(colors: Gradients().defaultCardBackground),
                                               startPoint: .bottomLeading,
                                               endPoint: .topTrailing),
                                lineWidth: 5))
            .padding()
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(image: UIImage())
    }
}
