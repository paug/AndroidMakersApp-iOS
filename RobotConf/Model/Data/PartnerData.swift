//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation

struct PartnerData: Decodable {
    let logoUrl: String
    let name: String
    let url: String?
}

struct PartnerCategoryData: Decodable {
    let order: Int
    let category: String
    let partners: [PartnerData]

    enum CodingKeys: String, CodingKey {
        case order
        case category = "title"
        case partners = "logos"
    }
}
