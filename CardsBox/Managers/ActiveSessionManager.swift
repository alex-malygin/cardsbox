//
//  ActiveSessionManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/19/21.
//

import Foundation

class ActiveSessionManager {
    private var dataManager: DataManagerProtocol
    let period = 600000
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        self.dataManager.lastActiveDate = 0
    }
    
    func checkLastSessionTime() -> Bool {
        let timestamp = Date().currentTimeMillis()
        if dataManager.lastActiveDate == 0 { return false }
        let currentPeriod = timestamp - dataManager.lastActiveDate
        return currentPeriod > period
    }
    
    func setNewLastSessionTime() {
        let timestamp = Date().currentTimeMillis()
        dataManager.lastActiveDate = timestamp
    }
}

extension Date {
    func currentTimeMillis() -> Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }
}
