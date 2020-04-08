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

/// Object that provides server partner
class PartnersProvider {
    struct Partner: Decodable {
        let logoUrl: String
        let name: String
        let url: String?
    }

    struct PartnerCategory: Decodable {
        let order: Int
        let category: String
        let partners: [Partner]

        enum CodingKeys: String, CodingKey {
            case order
            case category = "title"
            case partners = "logos"
        }
    }

    var partnersPublisher = PassthroughSubject<[PartnerCategory], Error>()

    init(database: Firestore) {
        database.collection("partners").getDocuments { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.partnersPublisher.send(completion: .failure(err))
            } else {
                do {
                    var partnerCategories = [PartnerCategory]()
                    for document in querySnapshot!.documents {
                        partnerCategories.append(try document.decoded())
                    }
                    self.partnersPublisher.send(partnerCategories)
                } catch let error {
                    self.partnersPublisher.send(completion: .failure(error))
                }
            }
        }
    }
}
