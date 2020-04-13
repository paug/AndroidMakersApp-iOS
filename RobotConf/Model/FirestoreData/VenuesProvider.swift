//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseCrashlytics

/// Object that provides server venues
class VenuesProvider {
    struct Venue: Decodable {
        let address: String
        let coordinates: String
        let description: String
        let descriptionFr: String
        let imageUrl: String
        let name: String
    }

    let confVenuePublisher = PassthroughSubject<Venue, Error>()
    let partyVenuePublisher = PassthroughSubject<Venue, Error>()

    init(database: Firestore) {
        database.collection("venues").document("conference").getDocument { [weak self] (document, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.confVenuePublisher.send(completion: .failure(err))
            } else {
                do {
                    self.confVenuePublisher.send(try document!.decoded())
                } catch let error {
                    Crashlytics.crashlytics().record(error: error)
                    self.confVenuePublisher.send(completion: .failure(error))
                }
            }
        }

        database.collection("venues").document("afterparty").getDocument { [weak self] (document, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.partyVenuePublisher.send(completion: .failure(err))
            } else {
                do {
                    self.partyVenuePublisher.send(try document!.decoded())
                } catch let error {
                    Crashlytics.crashlytics().record(error: error)
                    self.partyVenuePublisher.send(completion: .failure(error))
                }
            }
        }
    }
}
