//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation

struct SpeakerData: Decodable {
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
