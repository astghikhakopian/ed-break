//
//  HomeViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 07.11.22.
//

import SwiftUI

protocol HomeViewModeling: ObservableObject, Identifiable {
    
    var isLoading: Bool { get set }
    var contentModel: HomeModel? { get set }
    var remindingMinutes: Int { get set }
    var progress: Double { get set }
    var shieldSeconds: Int { get set }
    var isActiveWrongAnswersBlock: Bool { get }
    var shouldShowExercises: Bool  { get set }
    var doingSubject: SubjectModel? { get }
    
    func getSubjects()
    func checkConnection(compleated: @escaping (Bool)->())
}
