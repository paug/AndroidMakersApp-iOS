//
//  QueryDocumentSnapshot+Decodable.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 16/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// Extension of Firestore `DocumentSnapshot` that adds a way to decode it into a Decodable object
extension DocumentSnapshot {
    func decoded<T: Decodable>() throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data() ?? [:])
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try decoder.decode(T.self, from: jsonData)
    }
}
