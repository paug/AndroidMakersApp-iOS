//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation
import Combine

class AgendaRoomListViewModel: ObservableObject {
    struct Content {
        struct Session: Hashable {
            let data: Talk
            let startDateIdx: Int
            let duration: Int
            let rooms: ClosedRange<Int>
        }
        let rooms: [String]
        let hours: [Date]
        let sessions: [Session]

        func keepSessions(_ sessionUids: Set<String>) -> Self {
            let filteredSessions = sessions.filter { sessionUids.contains($0.data.uid) }
            return .init(rooms: rooms, hours: hours, sessions: filteredSessions)
        }
    }

    @Published private(set) var content = Content(rooms: [], hours: [], sessions: [])
    @Published private(set) var days = [Date]()
    @Published var favoriteTalks: Set<String> = []
    @Published var selectedDay = Date.distantFuture

    private var talkRepo: TalkRepository
    private var isDisplayed = false
    private var disposables = Set<AnyCancellable>()

    init(talkRepo: TalkRepository = model.talkRepository) {
        self.talkRepo = talkRepo

        talkRepo.getFavoriteTalks().sink { [unowned self] in
            // only update when view is displayed otherwise it will redisplay the list when the favorite state changes
            if self.isDisplayed {
                self.favoriteTalks = $0
            }
        }.store(in: &disposables)

        talkRepo.getTalks().sink { [unowned self] sessions in
            var allDates = Set<DateComponents>()
            let calendar = Calendar.current
            sessions.forEach { allDates.insert(calendar.dateComponents([.day, .month, .year], from: $0.startTime)) }
            let days = allDates.sorted {
                if $0.month == $1.month {
                    return $0.day ?? 0 < $1.day ?? 0
                }
                return $0.month ?? 0 < $1.month ?? 0
            }
            self.days = days.compactMap { calendar.date(from: $0) }
        }.store(in: &disposables)

        $days
            .removeDuplicates()
            .sink { [unowned self] days in
                guard let firstDay = days.first else { return }
                selectedDay = firstDay
            }.store(in: &disposables)

        Publishers.CombineLatest(
            talkRepo.getTalks(),
            $selectedDay)
        .sink { [unowned self] in
            talksChanged(talks: $0, selectedDay: $1)
        }.store(in: &disposables)
    }

    func viewAppeared() {
        isDisplayed = true

        // recompute talks in case status have changed
        talksChanged(talks: talkRepo.talks, selectedDay: selectedDay)
        favoriteTalks = talkRepo.favoriteTalks
    }

    func viewDisappeared() {
        isDisplayed = false
    }

    private func talksChanged(talks: [Talk], selectedDay: Date) {
        let calendar = Calendar.current
        let talksToConsider = talks.filter {
            calendar.isDate($0.startTime, inSameDayAs: selectedDay)
        }

        var allRooms = Set<Room>()
        talksToConsider.forEach { allRooms.insert($0.room) }
        let rooms = allRooms.sorted { $0.index < $1.index }
        let roomsIndexes = Dictionary(uniqueKeysWithValues: rooms.map { ($0.uid, Int(rooms.firstIndex(of: $0)!)) })

        var allTimes = Set<Date>()
        talksToConsider.forEach {
            allTimes.insert($0.startTime)
            allTimes.insert($0.startTime.addingTimeInterval($0.duration))
        }
        let times = allTimes.sorted()
        // filter small gaps (less than 10 minutes) in the schedule to only display the latest date
        var filteredTimes = [Date]()
        for (index, time) in times.enumerated() {
            guard index + 1 < times.count else {
                filteredTimes.append(time)
                continue
            }
            let nextTime = times[index + 1]
            if nextTime.timeIntervalSince(time) > 10 * 60 {
                filteredTimes.append(time)
            }
        }
        let timesIndex = Dictionary(uniqueKeysWithValues: filteredTimes.map { ($0, Int(filteredTimes.firstIndex(of: $0)!)) })

        var sessions = [Content.Session]()
        for session in talksToConsider {
            let endTime = session.startTime + session.duration
            guard let startDateIdx = timesIndex[session.startTime],
                  let roomIdx = roomsIndexes[session.room.uid],
                  let nearestEndTimeIdx = filteredTimes.firstIndex(where: { $0 >= endTime }) else {
                continue
            }

            let contentSession = Content.Session(data: session,
                                                 startDateIdx: startDateIdx,
                                                 duration: nearestEndTimeIdx - startDateIdx,
                                                 rooms: roomIdx...roomIdx)
            sessions.append(contentSession)
        }
        content = Content(rooms: rooms.map { $0.name }, hours: filteredTimes, sessions: sessions)
    }
}
