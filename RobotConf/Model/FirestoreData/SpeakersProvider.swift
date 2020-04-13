//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine

/// Object that provides server speakers
class SpeakersProvider {
    struct Speaker: Decodable {
        //let badges: Array<String>?
        let country: String?
        let featured: Bool?
        let companyLogo: String?
        let name: String?
        let photo: String?
        let bio: String?
        let shortBio: String?
        let company: String?
        //let socials: Array<String>?
        let order: Int?
    }

    var speakersPublisher = PassthroughSubject<[String: Speaker], Error>()

    init(database: Firestore) {
        database.collection("speakers").getDocuments { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.speakersPublisher.send(completion: .failure(err))
            } else {
                do {
                    var speakers = [String: Speaker]()
                    for document in querySnapshot!.documents {
                        speakers[document.documentID] = try document.decoded()
                    }
                    self.speakersPublisher.send(speakers)
                } catch let error {
                    self.speakersPublisher.send(completion: .failure(error))
                }
            }
        }
    }
}
