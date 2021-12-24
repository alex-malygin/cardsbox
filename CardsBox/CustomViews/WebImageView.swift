//
//  WebImageView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/6/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct WebImageView: View {
    var imageURL: String?
    var placeholder: UIImage
    var lineWidth: CGFloat
    
    var body: some View {
        WebImage(url: URL(string: imageURL ?? ""))
            .placeholder(content: {
                Image(uiImage: placeholder)
                    .resizable()
                    .scaledToFill()
            })
            .resizable()
            .clipShape(Circle())
            .shadow(radius: 8)
            .scaledToFill()
            .overlay(Circle()
                        .stroke(LinearGradient(gradient:
                                                Gradient(colors: Gradients().defaultCardBackground),
                                               startPoint: .bottom,
                                               endPoint: .top),
                                lineWidth: lineWidth))
            .padding()
    }
}
