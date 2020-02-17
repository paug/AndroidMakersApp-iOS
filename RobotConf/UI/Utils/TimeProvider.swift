//
//  TimeProvider.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 17/02/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import Foundation

class TimeProvider {
    static let instance = TimeProvider()

    // In debug, consider the launch of the app as the 23 avril 2019 11h59 16s GMT+2
    #if DEBUG
    private let fakeDate = Date(timeIntervalSince1970: 1556013588) // 23 avril 2019 11h59 16s GMT+2
    private let realDate = Date()
    #endif

    /// Private constructor
    private init() { }

    var currentTime: Date {
        #if DEBUG
        return fakeDate.addingTimeInterval(Date().timeIntervalSince(realDate))
        #else
        return Date()
        #endif
    }
}
