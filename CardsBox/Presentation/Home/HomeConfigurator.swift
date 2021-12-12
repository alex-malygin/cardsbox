//
//  HomeConfigurator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 12/11/21.
//

import Foundation

final class HomeConfigurator {
    public static func configureHomeView() -> HomeView {
        let viewModel = HomeViewModel(firestoreService: ServiceConfigurator.makeFirestoreService())
        let view = HomeView(viewModel: viewModel)
        return view
    }
}
