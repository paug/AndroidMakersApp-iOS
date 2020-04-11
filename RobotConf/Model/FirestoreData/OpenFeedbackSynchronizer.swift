//
//  OpenFeedback.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 09/02/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import Combine

class OpenFeedbackSynchronizer {

    private static let projectId = "mMHR63ARZQpPidFQISyc"

    struct UserVote: Codable {
        enum Status: String, Codable {
            case active
            case deleted
        }

        private let createdAt: Timestamp
        let id: String
        let projectId = OpenFeedbackSynchronizer.projectId
        let status: Status
        let talkId: String
        private let updatedAt: Timestamp
        let userId: String
        let voteItemId: String

        var creationDate: Date { createdAt.dateValue() }
        var updateDate: Date { updatedAt.dateValue() }
    }

    struct Config: Decodable {
        struct VoteItem: Decodable {
            let id: String
            let languages: [String: String]?
            let name: String
            let position: Int?
            let type: String
        }
        let chipColors: [String]
        let voteItems: [VoteItem]
    }

    struct UserVoteIdentifier: Hashable {
        let talkId: String
        let voteItemId: String
    }

    let configPublisher = PassthroughSubject<Config, Error>()
    /// Number of votes indexed by vote item indexed by session
    let sessionVotesPublisher = PassthroughSubject<[String: [String: Int]], Error>()
    let userVotesPublisher = PassthroughSubject<[UserVoteIdentifier: UserVote], Error>()

    private(set) var config: Config?
    private var userVotes = [UserVoteIdentifier: UserVote]()

    var userId: String?

    private let database: Firestore
    init?() {
        guard let plistPath = Bundle.main.path(forResource: "OpenFeedback-Info", ofType: "plist"),
            let config = NSDictionary(contentsOfFile: plistPath),
            let googleAppId = config["GOOGLE_APP_ID"] as? String,
            let gcmSenderID = config["GCM_SENDER_ID"] as? String,
            let projectId = config["PROJECT_ID"] as? String,
            let bundleId = config["BUNDLE_ID"] as? String,
            let apiKey = config["API_KEY"] as? String,
            let clientId = config["CLIENT_ID"] as? String,
            let databaseUrl = config["DATABASE_URL"] as? String,
            let storageBucket = config["STORAGE_BUCKET"] as? String else {
                print("Error: please embed a valid OpenFeedback-Info file in the main bundle")
                return nil
        }

        // Configure with manual options.
        let secondaryOptions = FirebaseOptions(googleAppID: googleAppId,
                                               gcmSenderID: gcmSenderID)
        secondaryOptions.projectID = projectId
        secondaryOptions.bundleID = bundleId
        secondaryOptions.apiKey = apiKey
        secondaryOptions.clientID = clientId
        secondaryOptions.databaseURL = databaseUrl
        secondaryOptions.storageBucket = storageBucket

        // Configure an alternative FIRApp.
        FirebaseApp.configure(name: "OpenFeedback", options: secondaryOptions)

        // Retrieve a previous created named app.
        guard let openFeedbackApp = FirebaseApp.app(name: "OpenFeedback") else {
            assert(false, "Could not retrieve openFeedback app")
            return nil
        }

        // Retrieve a Real Time Database client configured against a specific app.
        database = Firestore.firestore(app: openFeedbackApp)

        getConfig()
        getSessionsFeedbacks()

        Auth.auth(app: openFeedbackApp).signInAnonymously { authResult, _ in
            guard let user = authResult?.user else { return }
            print("User id: \(user.uid)")
            self.userId = user.uid
            self.getUserFeedbacks(user: user)
        }
    }

    func vote(_ voteItem: Config.VoteItem, for talkId: String) {
        let userVoteIdentifier = UserVoteIdentifier(talkId: talkId, voteItemId: voteItem.id)
        if let userVote = userVotes[userVoteIdentifier] {
            updateVote(userVote, status: .active)
        } else {
            createVote(voteItem, for: talkId)
        }
    }

    func deleteVote(_ voteItem: Config.VoteItem, of talkId: String) {
        let userVoteIdentifier = UserVoteIdentifier(talkId: talkId, voteItemId: voteItem.id)
        guard let userVote = userVotes[userVoteIdentifier] else { return }
        updateVote(userVote, status: .deleted)
    }

    private func getUserFeedbacks(user: User) {
        database.collection("projects/\(Self.projectId)/userVotes").whereField("userId", isEqualTo: user.uid)
            .addSnapshotListener { [weak self] (querySnapshot, err) in
                guard let self = self else { return }
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.userVotesPublisher.send(completion: .failure(err))
                } else {
                    do {
                        self.userVotes = [:]
                        for document in querySnapshot!.documents {
                            let userVote = try FirestoreDecoder().decode(UserVote.self, from: document.data())
                            let userVoteIdentifier = UserVoteIdentifier(
                                talkId: userVote.talkId, voteItemId: userVote.voteItemId)
                            self.userVotes[userVoteIdentifier] = userVote
                        }
                        self.userVotesPublisher.send(self.userVotes)
                    } catch let error {
                        print(error)
                        self.userVotesPublisher.send(completion: .failure(error))
                    }
                }
        }
    }

    private func getSessionsFeedbacks() {
        database.collection("projects/\(Self.projectId)/sessionVotes")
            .addSnapshotListener { [weak self] (querySnapshot, err) in

                guard let self = self else { return }
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.sessionVotesPublisher.send(completion: .failure(err))
                } else {
                    do {
                        var sessionVotes = [String: [String: Int]]()
                        for document in querySnapshot!.documents {
                            sessionVotes[document.documentID] = try document.decoded()
                        }
                        self.sessionVotesPublisher.send(sessionVotes)
                    } catch let error {
                        self.sessionVotesPublisher.send(completion: .failure(error))
                    }
                }
        }
    }

    private func getConfig() {
        database.collection("projects")
            .document(Self.projectId)
            .addSnapshotListener { [weak self] document, err in
                guard let self = self else { return }
                if let err = err {
                    print("Error getting document: \(err)")
                    self.config = nil
                    self.configPublisher.send(completion: .failure(err))
                } else {
                    do {
                        let config: Config = try FirestoreDecoder().decode(Config.self, from: document?.data() ?? [:])
                        self.config = config
                        self.configPublisher.send(config)
                    } catch let error {
                        print(error)
                        self.config = nil
                        self.configPublisher.send(completion: .failure(error))
                    }
                }
        }
    }

    private func createVote(_ voteItem: Config.VoteItem, for talkId: String) {
        guard let userId = userId else {
            return
        }
        let uid = database.collection("projects/\(Self.projectId)/userVotes").document().documentID
        let date = Date()
        database.collection("projects/\(Self.projectId)/userVotes").document(uid).setData([
            "createdAt": date,
            "id": uid,
            "projectId": Self.projectId,
            "status": "active",
            "talkId": talkId,
            "updatedAt": date,
            "userId": userId,
            "voteItemId": voteItem.id
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    private func updateVote(_ vote: UserVote, status: UserVote.Status) {
        database.collection("projects/\(Self.projectId)/userVotes").document(vote.id).setData([
            "createdAt": vote.creationDate,
            "id": vote.id,
            "projectId": vote.projectId,
            "status": status.rawValue,
            "talkId": vote.talkId,
            "updatedAt": Date(),
            "userId": vote.userId,
            "voteItemId": vote.id
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
