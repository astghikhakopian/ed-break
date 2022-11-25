//
//  PagingDto.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

struct PagingDto<R: Codable>: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [R]
}

struct ChildDto: Codable {
    let id: Int
    let name: String
    let grade: Int
    let restrictionTime: Int?
    let photo: String?
    let todayAnswers: Int?
    let todayCorrectAnswers: Int?
    let percentageToday: Float?
    let percentageProgress: Float?
    let lastLogin: String?
}

struct DataContainerDto<T: Codable>: Codable {
    let data: T
}

struct CoachingChildDto: Codable {
    let childName: String
    let childId: Int
    let correctAnswers: Int
    let correctPercent: Float?
    let childPhoto: String?
    let previousDifference: Float?
    let grade: Int
    let questionsCount: Int?
    let answersCount: Int?
    let subjects: [CoachingSubjectDto]?
}

struct CoachingSubjectDto: Codable {
    let prevCorrectCount: Int
    let questionsCount: Int
    let id: Int
    let title: String
    let subPreviousDifference: Float
    let correctAnswersCount: Int
    let answersCount: Int
}
