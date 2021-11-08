//
//  WebImageView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/6/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct WebImageView: View {
    var imageURL: URL?
    var placeholder: UIImage
    
    var body: some View {
        WebImage(url: imageURL)
            .placeholder(content: {
                Image(uiImage: placeholder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            })
            .resizable()
            .frame(width: 150, height: 150, alignment: .center)
            .clipShape(Circle())
            .shadow(radius: 8)
            .overlay(Circle()
                        .stroke(LinearGradient(gradient:
                                                Gradient(colors: Gradients().defaultCardBackground),
                                               startPoint: .bottom,
                                               endPoint: .top),
                                lineWidth: 8))
            .padding()
    }
}
