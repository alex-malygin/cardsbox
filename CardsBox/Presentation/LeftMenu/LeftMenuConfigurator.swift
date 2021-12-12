//
//  LeftMenuConfigurator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 12/12/21.
//

import Foundation
import SwiftUI

final class LeftMenuConfigurator {
    public static func configureLeftMenu() -> LeftMenu {
        let viewModel = LeftMenuViewModel()
        let view = LeftMenu(viewModel: viewModel)
        return view
    }
}
