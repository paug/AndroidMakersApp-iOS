//
//  DataProvider.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 16/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine
import CoreLocation

/// Object that transforms and provides model data from server data
class DataProvider {
    var talksPublisher = PassthroughSubject<[Talk], Error>()
    var confVenuePublisher = PassthroughSubject<Venue, Error>()
    var partyVenuePublisher = PassthroughSubject<Venue, Error>()
    var partnerPublisher = PassthroughSubject<[PartnerCategory], Error>()

    private let sessionsProvider: SessionsProvider
    private let speakersProvider: SpeakersProvider
    private let slotsProvider: SlotsProvider
    private let venuesProvider: VenuesProvider
    private let partnersProvider: PartnersProvider

    private var cancellables: Set<AnyCancellable> = []

    init() {
        let database = Firestore.firestore()
        sessionsProvider = SessionsProvider(database: database)
        speakersProvider = SpeakersProvider(database: database)
        slotsProvider = SlotsProvider(database: database)
        venuesProvider = VenuesProvider(database: database)
        partnersProvider = PartnersProvider(database: database)

        computeTalks()
        computeVenues()
        computePartners()
    }

    private func computeTalks() {
        sessionsProvider.sessionsPublisher
            .combineLatest(speakersProvider.speakersPublisher, slotsProvider.slotsPublisher)
            .sink(receiveCompletion: { error in
                print("Dja EEERRRROR \(error)")
        }) { [unowned self] (sessions, speakers, slots) in
            var talks = [Talk]()
            for (sessionId, session) in sessions {
                let sessionSpeakers = session.speakers?.compactMap { speakerId -> Speaker? in
                    if let speaker = speakers[speakerId] {
                        return Speaker(name: speaker.name ?? "", photoUrl: speaker.photo,
                                       company: speaker.company ?? "", description: speaker.bio ?? "")
                    }
                    // else raise an error

                    return nil
                } ?? []
                guard let slot = slots.first(where: { $0.sessionId == sessionId }) else {
                    // if no slot, no need to get the session
                    continue
                }
                let duration = slot.endDate.timeIntervalSince(slot.startDate)
                let talk = Talk(
                    uid: sessionId, title: session.title, description: session.description,
                    duration: duration, speakers: sessionSpeakers,
                    startTime: slot.startDate,
                    room: slot.roomId.capitalized, language: Language(from: session.language))
                talks.append(talk)
            }
            self.talksPublisher.send(talks)
        }.store(in: &cancellables)
    }

    private func computeVenues() {
        venuesProvider.confVenuePublisher
            .sink(receiveCompletion: { error in
                print("Dja EEERRRROR \(error)")
            }) { [unowned self] venue in
                guard let confVenue = Venue(from: venue) else {
                    //self.confVenuePublisher.send(completion: .failure())
                    return
                }

                self.confVenuePublisher.send(confVenue)
        }.store(in: &cancellables)

        venuesProvider.partyVenuePublisher
            .sink(receiveCompletion: { error in
                print("Dja EEERRRROR \(error)")
            }) { [unowned self] venue in
                guard let partyVenue = Venue(from: venue) else {
                    //self.partyVenuePublisher.send(completion: .failure())
                    return
                }

                self.partyVenuePublisher.send(partyVenue)
        }.store(in: &cancellables)
    }

    private func computePartners() {
        partnersProvider.partnersPublisher
            .sink(receiveCompletion: { error in
                print("Dja EEERRRROR \(error)")
            }) { [unowned self] partnerCategories in
                self.partnerPublisher.send([PartnerCategory](from: partnerCategories))
        }.store(in: &cancellables)
    }
}

extension Language {
    init(from str: String?) {
        guard let str = str else {
            self = .all
            return
        }
        var language: Language = []
        if str.localizedCaseInsensitiveContains("english") {
            language.formUnion(.english)
        }
        if str.localizedCaseInsensitiveContains("french") {
            language.formUnion(.french)
        }
        self = language
    }
}

private extension Venue {
    init?(from venue: VenuesProvider.Venue) {
        let coords = venue.coordinates.split(separator: ",")
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        guard coords.count == 2,
            let latitude = formatter.number(from: String(coords[0]))?.doubleValue,
            let longitude = formatter.number(from: String(coords[1]))?.doubleValue else {
            return nil
        }
        self = Venue(name: venue.name, description: venue.description, descriptionFr: venue.descriptionFr,
                     address: venue.address,
                     coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                     imageUrl: venue.imageUrl)
    }
}

private extension Array where Element == PartnerCategory {
    init(from partnerCategories: [PartnersProvider.PartnerCategory]) {
        self = partnerCategories
            .sorted { $0.order < $1.order }
            .compactMap { category in
                let partners = category.partners.compactMap { Partner(from: $0) }
                guard !partners.isEmpty else { return nil }
                return PartnerCategory(categoryName: category.category, partners: partners)
        }
    }
}

private extension Partner {
    init?(from partner: PartnersProvider.Partner) {
        let logoUrlStr = partner.logoUrl
            .replacingOccurrences(of: "..", with: "")
            .replacingOccurrences(of: ".svg", with: ".png")
        guard let logoUrl = URL(string: "https://androidmakers.fr\(logoUrlStr)"),
            let url = URL(string: partner.url) else { return nil }
        self.init(name: partner.name, logoUrl: logoUrl, url: url)
    }
}
