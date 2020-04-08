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
    var votesPublisher = PassthroughSubject<[String: TalkFeedback], Error>()

    private let sessionsProvider: SessionsProvider
    private let speakersProvider: SpeakersProvider
    private let slotsProvider: SlotsProvider
    private let roomsProvider: RoomsProvider
    private let venuesProvider: VenuesProvider
    private let partnersProvider: PartnersProvider
    private let openFeedbackSynchronizer = OpenFeedbackSynchronizer()

    private var cancellables: Set<AnyCancellable> = []

    init() {
        let database = Firestore.firestore()
        sessionsProvider = SessionsProvider(database: database)
        speakersProvider = SpeakersProvider(database: database)
        slotsProvider = SlotsProvider(database: database)
        roomsProvider = RoomsProvider(database: database)
        venuesProvider = VenuesProvider(database: database)
        partnersProvider = PartnersProvider(database: database)

        computeTalks()
        computeVenues()
        computePartners()
        computeVotes()
    }

    func vote(_ proposition: TalkFeedback.Proposition, for talkId: String) {
        guard let openFeedbackSynchronizer = openFeedbackSynchronizer,
            let voteItm = openFeedbackSynchronizer.config?.voteItems.first(where: { $0.id == proposition.uid })
            else { return }
        openFeedbackSynchronizer.vote(voteItm, for: talkId)
    }

    func removeVote(_ proposition: TalkFeedback.Proposition, for talkId: String) {
        guard let openFeedbackSynchronizer = openFeedbackSynchronizer,
            let voteItm = openFeedbackSynchronizer.config?.voteItems.first(where: { $0.id == proposition.uid })
            else { return }
        openFeedbackSynchronizer.deleteVote(voteItm, of: talkId)
    }

    private func computeTalks() {
        sessionsProvider.sessionsPublisher
            .combineLatest(speakersProvider.speakersPublisher, slotsProvider.slotsPublisher,
                           roomsProvider.roomsPublisher)
            .sink(receiveCompletion: { error in
                print("Dja EEERRRROR \(error)")
        }) { [unowned self] (sessions, speakers, slots, rooms) in
            var talks = [Talk]()
            for (sessionId, session) in sessions {
                let sessionSpeakers = session.speakers?.compactMap { speakerId -> Speaker? in
                    if let speaker = speakers[speakerId] {
                        // can force unwrap URL because URL(string: "") is returning a non nil url
                        return Speaker(name: speaker.name ?? "", photoUrl: URL(string: speaker.photo ?? "")!,
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
                    room: rooms[slot.roomId]?.roomName ?? slot.roomId.capitalized,
                    language: Language(from: session.language))
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

    private func computeVotes() {
        guard let openFeedbackSynchronizer = openFeedbackSynchronizer else { return }
        openFeedbackSynchronizer.configPublisher
            .combineLatest(openFeedbackSynchronizer.sessionVotesPublisher,
                           openFeedbackSynchronizer.userVotesPublisher,
                           slotsProvider.slotsPublisher)
            .sink(receiveCompletion: { error in
                print("Dja EEERRRROR \(error)")
            }) { [unowned self] config, sessionVotes, userVotes, slots in
                let preferredLanguage = Bundle.main.preferredLocalizations[0]
                let propositions = config.voteItems.sorted { $0.position ?? 0 > $1.position ?? 0 }
                    .compactMap { TalkFeedback.Proposition(from: $0, language: preferredLanguage) }
                let propositionDict = Dictionary(uniqueKeysWithValues: propositions.map { ($0.uid, $0) })
                let colors = config.chipColors.map { UIColor(hexString: $0) }

                var talkVotes = [String: TalkFeedback]()
                slots.forEach { slot in
                    let talkId = slot.sessionId
                    let votes = sessionVotes[talkId] ?? [:]
                    var infos = [TalkFeedback.Proposition: TalkFeedback.PropositionInfo]()
                    votes.forEach { vote in
                        if let proposition = propositionDict[vote.key] {
                            let identifier = OpenFeedbackSynchronizer.UserVoteIdentifier(
                                talkId: talkId, voteItemId: vote.key)
                            let hasVoted = userVotes[identifier]?.status == .active
                            infos[proposition] = TalkFeedback.PropositionInfo(numberOfVotes: vote.value,
                                                                          userHasVoted: hasVoted)
                        }
                    }
                    let talkVote = TalkFeedback(talkId: talkId, colors: colors, propositions: propositions,
                                            propositionInfos: infos)
                    talkVotes[talkId] = talkVote
                }
                self.votesPublisher.send(talkVotes)
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
        guard let logoUrl = URL(string: "https://androidmakers.fr\(logoUrlStr)") else { return nil }
        self.init(name: partner.name, logoUrl: logoUrl, url: URL(string: partner.url))
    }
}

private extension TalkFeedback.Proposition {
    init?(from voteItem: OpenFeedbackSynchronizer.Config.VoteItem, language: String) {
        guard voteItem.type == "boolean" else { return nil }
        self = TalkFeedback.Proposition(uid: voteItem.id, text: voteItem.languages[language] ?? voteItem.name)
    }
}
