//
//  AboutViewModel.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 05/01/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import Foundation
import Combine
import UIKit

class AboutViewModel: ObservableObject, Identifiable {

    @Published var partnerCategories = [PartnerCategory]()

    private var disposables = Set<AnyCancellable>()

    init(partnerRepo: PartnerRepository = model.partnerRepository) {
        partnerRepo.getPartners()
            .sink { [weak self] in
                self?.partnerCategories = $0
        }.store(in: &disposables)
    }

    func openFaqPage() {
        UIApplication.shared.open(URL(string: "https://androidmakers.fr/faq")!)
    }

    func openCodeOfConductPage() {
        UIApplication.shared.open(URL(string: "https://androidmakers.fr/cod")!)
    }

    func openTwitterPage() {
        let screenName = "@AndroidMakersFR"
        let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = URL(string: "https://twitter.com/\(screenName)")!

        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
             application.open(appURL)
        } else {
             application.open(webURL)
        }
    }

    func openHashtagPage() {
        let screenName = "AndroidMakers"
        let appURL = URL(string: "twitter://search?query=\(screenName)")!
        let webURL = URL(string: "https://twitter.com/search?q=\(screenName)")!

        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
             application.open(appURL)
        } else {
             application.open(webURL)
        }
    }

    func openYoutubePage() {
        let user =  "UCkatLlah5weIpN23LqMgdTg"
        let appURL = URL(string: "youtube://www.youtube.com/channel/\(user)")!
        let webURL = URL(string: "https://www.youtube.com/channel/\(user)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL)
        }
    }

    func openPartnerPage(_ partner: Partner) {
        UIApplication.shared.open(partner.url)
    }
}
