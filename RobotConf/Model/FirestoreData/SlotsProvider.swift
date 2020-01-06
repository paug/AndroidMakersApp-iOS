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

    init(db: Firestore) {
        db.collection("schedule-app").document("slots").getDocument { [weak self] (document, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.slotsPublisher.send(completion: .failure(err))
            } else {
                do {
                    let slots: Slots = try document!.decoded()
                    self.slotsPublisher.send(slots.all)
                } catch let e {
                    self.slotsPublisher.send(completion: .failure(e))
                }
            }
        }
    }
}
