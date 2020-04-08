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

/// Object that provides server rooms
class RoomsProvider {
    struct Room: Decodable {
        let roomId: String
        let roomName: String
    }

    private struct Rooms: Decodable {
        let allRooms: [Room]
    }

    var roomsPublisher = PassthroughSubject<[String: Room], Error>()

    init(database: Firestore) {
        database.collection("schedule-app").document("rooms").getDocument { [weak self] (document, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.roomsPublisher.send(completion: .failure(err))
            } else {
                do {
                    let rooms: Rooms = try document!.decoded()
                    self.roomsPublisher.send(Dictionary(uniqueKeysWithValues: rooms.allRooms.map { ($0.roomId, $0) }))
                } catch let error {
                    self.roomsPublisher.send(completion: .failure(error))
                }
            }
        }
    }
}
