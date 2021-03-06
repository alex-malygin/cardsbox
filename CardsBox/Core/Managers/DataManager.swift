//
//  DataManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/30/21.
//

import Foundation
import Combine

class DataManager {
    static let shared = DataManager()
    private let defaults = UserDefaults.standard
    
    struct Keys {
        static let loginByBiometric = "loginByBiometric"
        static let interfaceStyle = "interfaceStyle"
        static let userID = "userID"
        static let lastActiveDate = "lastActiveDate"
    }
    
    let subject = PassthroughSubject<UserProfileModel?, Never>()
    
    var userProfile: UserProfileModel? {
        didSet {
            debugPrint("[😁]", userProfile?.email as Any)
            subject.send(userProfile)
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
