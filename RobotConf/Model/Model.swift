//
//  Engine.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 29/12/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation

let model = Model()

class Model {
    private let dataProvider = DataProvider() // A strong ref on the data provider must be kept
    let talkRepository: TalkRepository
    let venueRepository: VenueRepository

    init() {
        talkRepository = TalkRepository(dataProvider: dataProvider)
        venueRepository = VenueRepository(dataProvider: dataProvider)
    }
}
