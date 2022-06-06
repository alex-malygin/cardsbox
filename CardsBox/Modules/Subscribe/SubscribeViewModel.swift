//
//  SubscribeViewModel.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/26/22.
//  Copyright (c) 2022. All rights reserved.
//

import UIKit

protocol SubscribeViewModelType {
    var inputs: SubscribeViewModelInputs { get }
    var outputs: SubscribeViewModelOutputs { get }
    var routes: SubscribeViewModelRoutes { get }
}

protocol SubscribeViewModelInputs {
    func viewDidLoad()
}

protocol SubscribeViewModelOutputs: AnyObject {
    var staticValues: SubscribeStaticValuesProtocol { get }
    var showAlert: ItemClosure<[SubscribeAlert]>? { get set }
    var showLoader: ItemClosure<Bool>? { get set }
    var reloadData: VoidClosure? { get set }
}

protocol SubscribeViewModelRoutes: AnyObject {
    var backAction: VoidClosure? { get set }
}

protocol SubscribeStaticValuesProtocol {
    var title: String { get }
}

enum SubscribeAlert {
    case other(message: String)

    var message: String {
        switch self {
        case let .other(message): return message
        }
    }
}

final class SubscribeViewModel: SubscribeViewModelOutputs, SubscribeViewModelType, SubscribeViewModelRoutes {
    // MARK: - SubscribeViewModelType
    var inputs: SubscribeViewModelInputs { return self }
    var outputs: SubscribeViewModelOutputs { return self }
    var routes: SubscribeViewModelRoutes { return self }

    struct StaticValues: SubscribeStaticValuesProtocol {
        var title: String { "New" }
    }
    
    //MARK: - Private properties

    //MARK: - Init
    init() { }

    // MARK: - SubscribeViewModelOutputs
    var staticValues: SubscribeStaticValuesProtocol = StaticValues()
    var showAlert: ItemClosure<[SubscribeAlert]>?
    var showLoader: ItemClosure<Bool>?
    var reloadData: VoidClosure?

    // MARK: - SubscribeViewModelRoutes
    var backAction: VoidClosure?
}

// MARK: - SubscribeViewModelInputs
extension SubscribeViewModel: SubscribeViewModelInputs {
    func viewDidLoad() {
        reloadData?()
    }
}
