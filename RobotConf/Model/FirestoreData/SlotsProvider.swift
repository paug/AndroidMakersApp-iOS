//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseCrashlytics

/// Object that provides server slots
class SlotsProvider {
    struct Slot: Decodable {
        let sessionId: String
        let roomId: String
        let startDate: Date
        let endDate: Date
    }

    private struct Slots: Decodable {
        let all: [Slot]
    }

    var slotsPublisher = PassthroughSubject<[Slot], Error>()

    init(database: Firestore) {
        database.collection("schedule-app").document("slots").getDocument { [weak self] (document, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.slotsPublisher.send(completion: .failure(err))
            } else {
                do {
                    let slots: Slots = try document!.decoded()
                    self.slotsPublisher.send(slots.all)
                } catch let error {
                    Crashlytics.crashlytics().record(error: error)
                    self.slotsPublisher.send(completion: .failure(error))
                }
            }
        }
    }
}
