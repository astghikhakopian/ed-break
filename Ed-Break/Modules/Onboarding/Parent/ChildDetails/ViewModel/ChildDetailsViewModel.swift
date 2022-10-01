//
//  ChildDetailsViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import UIKit

final class ChildDetailsViewModel: ChildDetailsViewModeling, Identifiable {
    
    @Published var image: UIImage = UIImage()
    @Published var childName: String = ""
    @Published var grade: Grade = .first
    @Published var grades: [Grade] = Grade.allCases
}


// MARK: - Preview

final class MockChildDetailsViewModel: ChildDetailsViewModeling, Identifiable {
    
    var image = UIImage()
    var childName = ""
    var grade = Grade.first
    var grades = Grade.allCases
}
