//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation

/// Singleton model
let model = Model()

/// The model API object
class Model {
    private let dataProvider = DataProvider() // A strong ref on the data provider must be kept
    let talkRepository: TalkRepository
    let venueRepository: VenueRepository
    let partnerRepository: PartnerRepository
    let feedbackRepository: FeedbackRepository

    init() {
        talkRepository = TalkRepository(dataProvider: dataProvider)
        venueRepository = VenueRepository(dataProvider: dataProvider)
        partnerRepository = PartnerRepository(dataProvider: dataProvider)

        feedbackRepository = FeedbackRepository(dataProvider: dataProvider)
    }
}
