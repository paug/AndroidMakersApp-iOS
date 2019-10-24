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

class SessionProvider {
    struct Session: Decodable {
        let complexity: String?
        let speakers: [String]?
        let description: String
        let language: String?
        let title: String
        let tags: [String]
        let videoURL: String?
    }

    var sessionPublisher = PassthroughSubject<[String: Session], Error>()

    init(db: Firestore) {
        db.collection("sessions").getDocuments() { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.sessionPublisher.send(completion: .failure(err))
            } else {
                do {
                    var sessions = [String: Session]()
                    for document in querySnapshot!.documents {
                        sessions[document.documentID] = try document.decoded()
                    }
                    self.sessionPublisher.send(sessions)
                } catch let e {
                    self.sessionPublisher.send(completion: .failure(e))
                }
            }
        }
    }
}
