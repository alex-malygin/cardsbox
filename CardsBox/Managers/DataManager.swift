//
//  DataManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/30/21.
//

import Foundation
import Combine

protocol DataManagerProtocol {
    var userProfile: UserProfileModel? { get set }
    var isBiometriAvialable: Bool { get set }
    var lastActiveDate: Int { get set }
}

final class DataManager: DataManagerProtocol {
    static let shared = DataManager()
    private let defaults = UserDefaults.standard
    
    struct Keys {
        static let loginByBiometric = "loginByBiometric"
        static let lastActiveDate = "lastActiveDate"
    }
    
    var userProfile: UserProfileModel? {
        didSet {
            debugPrint("[😁]", userProfile?.email as Any)
        }
    }
    
    var isBiometriAvialable: Bool {
        get { defaults.bool(forKey: Keys.loginByBiometric) }
        set { defaults.set(newValue, forKey: Keys.loginByBiometric) }
    }
    
    var lastActiveDate: Int {
        get { defaults.integer(forKey: Keys.lastActiveDate) }
        set { defaults.set(newValue, forKey: Keys.lastActiveDate) }
    }
}
