//
//  SessionProvider.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 16/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine

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

    init(db: Firestore) {
        db.collection("venues").document("conference").getDocument { [weak self] (document, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.confVenuePublisher.send(completion: .failure(err))
            } else {
                do {
                    self.confVenuePublisher.send(try document!.decoded())
                } catch let e {
                    self.confVenuePublisher.send(completion: .failure(e))
                }
            }
        }

        db.collection("venues").document("afterparty").getDocument { [weak self] (document, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.partyVenuePublisher.send(completion: .failure(err))
            } else {
                do {
                    self.partyVenuePublisher.send(try document!.decoded())
                } catch let e {
                    self.partyVenuePublisher.send(completion: .failure(e))
                }
            }
        }
    }
}
