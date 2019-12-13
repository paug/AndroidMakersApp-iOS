//
//  TalkRepository.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 08/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation
import Combine

let talkRepository = TalkRepository()

class TalkRepository {
    @Published private var talks = [Talk]()

    let dataProvider = DataProvider()

    private var cancellables: Set<AnyCancellable> = []

    init() {
        //dataProvider.getSessions()
//        talks = [
//            Talk(id: "1", title: "Office Hours", description: "Lorem ipsum",
//                 duration: 40 * 60,
//                 speakers: [Speaker(name: "Toto Toto", photoUrl: "/images/people/florent_champigny.jpg", company: "",
//                                    description: "")],
//                 startTime: Date(timeIntervalSinceReferenceDate: 0),
//                 room: "Blin", language: .french),
//            Talk(id: "2", title: "Lunch", description: """
//                Lorem ipsum dolor sit amet, consectetur adipiscing elit.
//                Aenean tempor eros eu hendrerit feugiat. In pharetra, diam sed sollicitudin sollicitudin, elit eros
//                aliquet nunc, in convallis nisl ex nec lacus. Donec vitae nunc et nisi egestas dignissim.
//                Nam mollis vel nulla a maximus. Etiam vulputate leo et elit consectetur molestie.
//                Maecenas condimentum, libero et rutrum ultricies, lacus est laoreet ligula,
//                eu volutpat tellus neque ac justo. Class aptent taciti sociosqu ad litora torquent per
//                conubia nostra, per inceptos himenaeos. Pellentesque purus leo, ornare id nisl at, auctor porttitor dui.
//
//                Mauris eu bibendum libero, nec tristique lorem. Nunc augue ipsum, vestibulum vel porttitor sit amet,
//                vestibulum a tellus. Cras hendrerit blandit felis eget ultrices. Ut sit amet nunc mi.
//                Praesent varius mauris quis molestie vulputate. Donec ac nulla tortor.
//                In sit amet elementum nisl. Integer ac lectus lobortis erat malesuada tempor sed ut felis.
//                Duis quis ipsum sollicitudin, condimentum nunc quis, pellentesque velit. Sed ullamcorper orci
//                vel tellus viverra, et molestie dui aliquam. Ut et iaculis augue.
//                Nam purus felis, hendrerit id auctor vitae, dictum eget mi.
//                Sed nec justo malesuada, faucibus ante et, euismod sem. Morbi commodo volutpat feugiat.
//                """,
//                 duration: 20 * 60,
//                 speakers: [Speaker(name: "Tato Tato", photoUrl: "/images/people/florent_champigny.jpg", company: "",
//                                    description: "")],
//                 startTime: Date(timeIntervalSinceReferenceDate: 10 * 60),
//                 room: "Blin", language: .french),
//            Talk(id: "3", title: "Workout your tasks with WorkManager", description: "Lorem ipsum",
//                 duration: 20 * 60,
//                 speakers: [Speaker(name: "Magda Miu", photoUrl: "/images/people/florent_champigny.jpg", company: "",
//                                    description: "")],
//                 startTime: Date(timeIntervalSinceReferenceDate: 0 * 60),
//                 room: "Blin", language: .english),
//            Talk(id: "4", title: "Embarquez dans l'aventure Kotlin avec Advent Of Code", description: "Lorem ipsum",
//                 duration: 60 * 60,
//                 speakers: [Speaker(name: "Hugo Hache", photoUrl: "/images/people/florent_champigny.jpg",
//                                    company: "", description: "")],
//                 startTime: Date(timeIntervalSinceReferenceDate: 20 * 60 * 60),
//                 room: "Blin", language: .french)]
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.talks.append(contentsOf: [
//                Talk(id: "5", title: "New awesome talk", description: "Lorem ipsum",
//                     duration: 30 * 60,
//                     speakers: [Speaker(name: "Tato Tato", photoUrl: "/images/people/florent_champigny.jpg",
//                                        company: "", description: ""),
//                                Speaker(name: "Djavan Bertrand", photoUrl: "/images/people/florent_champigny.jpg",
//                                        company: "", description: "")],
//                     startTime: Date(timeIntervalSinceReferenceDate: 10 * 60), room: "Room 2.04",
//                     language: .all),
//                Talk(id: "6", title: "Recruteurs, développeurs, bonne humeur", description: "Lorem ipsum",
//                     duration: 30 * 60,
//                     speakers: [Speaker(name: "David Fournier", photoUrl: "/images/people/florent_champigny.jpg",
//                                        company: "", description: ""),
//                                Speaker(name: "Djavan Bertrand", photoUrl: "/images/people/florent_champigny.jpg",
//                                        company: "", description: "")],
//                     startTime: Date(timeIntervalSinceReferenceDate: 0 * 60), room: "Room 2.04",
//                     language: .all)])
//        }

        dataProvider.talksPublisher
            .replaceError(with: [])
            .sink { [unowned self] in
                self.talks = $0
        }
        .store(in: &cancellables)
    }

    func getTalks() -> AnyPublisher<[Talk], Never> {
        return $talks.eraseToAnyPublisher()
    }

    //    func getTalks() -> PassthroughSubject<[Talk], Never> {
    //        return $talks
    ////        return [
    ////            Talk(id: 1, title: "Office Hours", duration: 40 * 60,
    ////                 speakers: [Speaker(name: "Toto Toto", company: "", description: "")],
    ////                 startTime: Date(timeIntervalSinceReferenceDate: 0),
    ////                 room: "Blin", language: .french),
    ////            Talk(id: 2, title: "Lunch", duration: 20 * 60,
    ////                 speakers: [Speaker(name: "Tato Tato", company: "", description: "")],
    ////                 startTime: Date(timeIntervalSinceReferenceDate: 10 * 60),
    ////                 room: "Blin", language: .french)]
    //    }
}
