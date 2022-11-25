//
//  ChildModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import Foundation

struct ChildModel: Equatable {
    var id: Int
    var name: String
    var grade: Grade
    var restrictionTime: Int?
    var photoUrl: URL?
    let todayAnswers: Int
    let todayCorrectAnswers: Int
    let percentageToday: Float
    let percentageProgress: Float
    let lastLogin: String
    
    init(dto: ChildDto) {
        id = dto.id
        name = dto.name
        grade = Grade(rawValue: dto.grade) ?? .first
        restrictionTime = dto.restrictionTime
        photoUrl = URL(string: dto.photo ?? "")
        
        todayAnswers = dto.todayAnswers ?? 0
        todayCorrectAnswers = dto.todayCorrectAnswers ?? 0
        percentageToday = dto.percentageToday ?? 0
        percentageProgress = dto.percentageProgress ?? 0
        lastLogin = dto.lastLogin ?? ""
    }
}

struct CoachingChildModel: Equatable {
    
    var id: Int
    var name: String
    var grade: Grade
    var photoUrl: URL?
    let todayAnswers: Int
    let todayCorrectAnswers: Int
    let percentageToday: Float
    let percentageProgress: Float
    let questionsCount: Int?
    let subjects: [CoachingSubjectModel]
    
    init(dto: CoachingChildDto) {
        id = dto.childId
        name = dto.childName
        grade = Grade(rawValue: dto.grade) ?? .first
        photoUrl = URL(string: dto.childPhoto ?? "")
        todayAnswers = dto.answersCount ?? 0
        todayCorrectAnswers = dto.correctAnswers
        percentageToday = dto.correctPercent ?? 0
        percentageProgress = dto.previousDifference ?? 0
        questionsCount = dto.questionsCount ?? 0
        subjects = dto.subjects?.map { CoachingSubjectModel(dto: $0) } ?? []
    }
    
    static func == (lhs: CoachingChildModel, rhs: CoachingChildModel) -> Bool {
        lhs.id == rhs.id
    }
}

struct CoachingSubjectModel {
    let prevCorrectCount: Int
    let questionsCount: Int
    let id: Int
    let title: String
    let subPreviousDifference: Float
    let correctAnswersCount: Int
    let answersCount: Int
    
    init(dto: CoachingSubjectDto) {
        prevCorrectCount = dto.prevCorrectCount
        questionsCount = dto.questionsCount
        id = dto.id
        title = dto.title
        subPreviousDifference = dto.subPreviousDifference
        correctAnswersCount = dto.correctAnswersCount
        answersCount = dto.answersCount
    }
}

struct PagingModel<R> {
    let count: Int
    let next: URL?
    let previous: URL?
    var results: [R]
    
    init(results: [R]) {
        self.count = results.count
        self.next = nil
        self.previous = nil
        self.results = results
    }
}
