//
//  OnboardingViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/26/22.
//  Copyright (c) 2022. All rights reserved.
//

import UIKit

protocol OnboardingViewModelType {
    var inputs: OnboardingViewModelInputs { get }
    var outputs: OnboardingViewModelOutputs { get }
    var routes: OnboardingViewModelRoutes { get }
}

protocol OnboardingViewModelInputs {
    func viewDidLoad()
}

protocol OnboardingViewModelOutputs: AnyObject {
    var staticValues: OnboardingStaticValuesProtocol { get }
    var showAlert: ItemClosure<[OnboardingAlert]>? { get set }
    var showLoader: ItemClosure<Bool>? { get set }
    var reloadData: VoidClosure? { get set }
}

protocol OnboardingViewModelRoutes: AnyObject {
    var backAction: VoidClosure? { get set }
}

protocol OnboardingStaticValuesProtocol {
    var title: String { get }
}

enum OnboardingAlert {
    case other(message: String)

    var message: String {
        switch self {
        case let .other(message): return message
        }
    }
}

final class OnboardingViewModel: OnboardingViewModelOutputs, OnboardingViewModelType, OnboardingViewModelRoutes {
    // MARK: - OnboardingViewModelType
    var inputs: OnboardingViewModelInputs { return self }
    var outputs: OnboardingViewModelOutputs { return self }
    var routes: OnboardingViewModelRoutes { return self }

    struct StaticValues: OnboardingStaticValuesProtocol {
        var title: String { "New" }
    }
    
    //MARK: - Private properties

    //MARK: - Init
    init() { }

    // MARK: - OnboardingViewModelOutputs
    var staticValues: OnboardingStaticValuesProtocol = StaticValues()
    var showAlert: ItemClosure<[OnboardingAlert]>?
    var showLoader: ItemClosure<Bool>?
    var reloadData: VoidClosure?

    // MARK: - OnboardingViewModelRoutes
    var backAction: VoidClosure?
}

// MARK: - OnboardingViewModelInputs
extension OnboardingViewModel: OnboardingViewModelInputs {
    func viewDidLoad() {
        reloadData?()
    }
}
