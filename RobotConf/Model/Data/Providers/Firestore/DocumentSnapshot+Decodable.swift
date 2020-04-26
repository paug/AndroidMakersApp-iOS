//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
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
