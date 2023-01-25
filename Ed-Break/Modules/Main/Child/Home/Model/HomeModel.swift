//
//  HomeModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 08.11.22.
//

import Foundation
import FamilyControls

struct HomeModel {
    
    let childId: Int
    let lastLogin: Date?
    let restrictionTime: Date?
    let restrictions: FamilyActivitySelection?
    var interruption: Int?
    var breakEndDatetime: Date?
    var breakStartDatetime: Date?
    let subjects: [SubjectModel]
    var wrongAnswersTime: Date?
    let deviceToken: String?
    
    init(dto: HomeDto) {
        childId = dto.childId
        deviceToken = dto.deviceToken
        lastLogin = Date(fromString: dto.lastLogin ?? "", format: .isoDateTimeFull)?.toLocalTime()
        restrictionTime = Date(fromString: dto.restrictions ?? "", format: .isoDateTimeFull)?.toLocalTime()
        breakStartDatetime = Date(fromString: dto.breakStartDatetime ?? "", format: .isoDateTimeFull)?.toLocalTime()
        breakEndDatetime = Date(fromString: dto.breakEndDatetime ?? "", format: .isoDateTimeFull)?.toLocalTime()
        wrongAnswersTime = Date(fromString: dto.wrongAnswersTime ?? "", format: .isoDateTimeFull)?.toLocalTime()
        interruption = dto.interruption
        subjects = dto.subjects.map { SubjectModel(dto: $0) }
        
        if let restrictions = dto.restrictions?.replacingOccurrences(of: "\\\"", with: "\""),
           let stringData = restrictions.data(using: .utf8),
           // let json = try? JSONSerialization.jsonObject(with: stringData),
           let selectionObject = try? JSONDecoder().decode(FamilyActivitySelection.self, from: stringData) {
            self.restrictions = selectionObject
        } else {
            restrictions = nil
        }
    }
}

struct SubjectModel: BottomsheetCellModel, Equatable {
    var title: String { subject ?? "" }
    var imageUrl: URL? { photo == nil ? nil : URL(string: photo!) }
    
    let id: Int
    let subject: String?
    let photo: String?
    let questionsCount: Int
    let completedCount: Int
    let correctAnswersCount: Int
    let completed: Bool
    
    init(dto: SubjectDto) {
        id = dto.id
        subject = dto.subject
        photo = dto.photo
        questionsCount = dto.questionsCount ?? 0
        completedCount = dto.completedCount ?? 0
        correctAnswersCount = dto.correctAnswersCount ?? 0
        completed = dto.completed ?? false
    }

    init(dto: CoachingSubjectDto) {
        id = dto.id
        subject = dto.title
        photo = dto.photo
        questionsCount = dto.questionsCount ?? 0
        completedCount = dto.answersCount ?? 0
        correctAnswersCount = dto.correctAnswersCount ?? 0
        completed = completedCount >= questionsCount
    }
    
    init() {
        self.id = 0
        self.subject = nil
        self.photo = nil
        self.questionsCount = 0
        self.completedCount = 0
        self.correctAnswersCount = 0
        self.completed = false
    }
}

extension Date {

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        
        // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = self.timeIntervalSince1970
        
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        
        
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        return Date(timeIntervalSince1970: timezoneEpochOffset)
    }

}
