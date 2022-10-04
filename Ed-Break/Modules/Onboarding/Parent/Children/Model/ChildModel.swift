//
//  ChildModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import Foundation

struct ChildModel {
    var id: Int
    var name: String
    var grade: Grade
    var restrictionTime: Int?
    var photoUrl: URL?
    
    init(dto: ChildDto) {
        id = dto.id
        name = dto.name
        grade = Grade(rawValue: dto.grade) ?? .first
        restrictionTime = dto.restrictionTime
        photoUrl = URL(string: dto.photo ?? "")
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
