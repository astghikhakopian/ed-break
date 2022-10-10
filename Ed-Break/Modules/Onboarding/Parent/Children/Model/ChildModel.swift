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
        lastLogin = dto.lastLogin ?? ""
    }
    
}

struct PagingModel<R> {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [R]
    
    init(results: [R]) {
        self.count = results.count
        self.next = nil
        self.previous = nil
        self.results = results
    }
}
