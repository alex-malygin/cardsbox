//
//  MainContainerConfigurator.swift
//  CardsBox
//
//  Created by Alexander Malygin on 12/11/21.
//

import Foundation
import SwiftUI

final class MainContainerConfigurator {
    public static func configureMainContainerView() -> MainContainer {
        return MainContainer(viewModel: MainContainerViewModel())
    }
}
