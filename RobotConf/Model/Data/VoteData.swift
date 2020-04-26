//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct UserVoteData: Codable {
    enum Status: String, Codable {
        case active
        case deleted
    }

    let createdAt: Timestamp
    // swiftlint:disable:next identifier_name - tried to allow `id` in config but did not work
    let id: String
    let status: Status
    let talkId: String
    let updatedAt: Timestamp
    let userId: String
    let voteItemId: String

    var creationDate: Date { createdAt.dateValue() }
    var updateDate: Date { updatedAt.dateValue() }
}

struct VoteConfigData: Decodable {
    struct VoteItem: Decodable {
        // swiftlint:disable:next identifier_name - tried to allow `id` in config but did not work
        let id: String
        let languages: [String: String]?
        let name: String
        let position: Int?
        let type: String
    }
    let chipColors: [String]
    let voteItems: [VoteItem]
}

struct UserVoteIdentifierData: Hashable {
    let talkId: String
    let voteItemId: String
}
