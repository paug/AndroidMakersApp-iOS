//
//  Talk.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 08/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation

struct Talk {
    let id: String
    let title: String
    let description: String
    let duration: TimeInterval
    let speakers: [Speaker]
    let startTime: Date
    let room: String
    let language: Language
}
