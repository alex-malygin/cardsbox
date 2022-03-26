//
//  ShareCardController.swift
//  CardsBox
//
//  Created by Alexander Malygin on 2/14/22.
//

import SwiftUI
import UIKit

struct ShareCardController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareCardController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareCardController>) {}
}
