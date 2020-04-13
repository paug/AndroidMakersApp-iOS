//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation

class TimeProvider {
    static let instance = TimeProvider()

    // In debug, consider the launch of the app as the 23 avril 2019 11h59 16s GMT+2
    #if DEBUG
    private let fakeDate = Date(timeIntervalSince1970: 1587384240) // Monday, 20 April 2020 14:04:00 GMT+02:00
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
