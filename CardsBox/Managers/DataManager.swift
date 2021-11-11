//
//  DataManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/30/21.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private let defaults = UserDefaults.standard
    
    struct Keys {
        static let loginByBiometric = "loginByBiometric"
        static let interfaceStyle = "interfaceStyle"
        static let userID = "userID"
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
}
