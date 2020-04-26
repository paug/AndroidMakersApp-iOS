//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseCrashlytics

/// Object that provides partners from Firestore
class FirestorePartnersProvider: PartnersProvider {
    var partnersPublisher = PassthroughSubject<[PartnerCategoryData], Error>()

    init(database: Firestore) {
        database.collection("partners").getDocuments { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
                self.partnersPublisher.send(completion: .failure(err))
            } else {
                do {
                    var partnerCategories = [PartnerCategoryData]()
                    for document in querySnapshot!.documents {
                        partnerCategories.append(try document.decoded())
                    }
                    self.partnersPublisher.send(partnerCategories)
                } catch let error {
                    Crashlytics.crashlytics().record(error: error)
                    self.partnersPublisher.send(completion: .failure(error))
                }
            }
        }
    }
}
