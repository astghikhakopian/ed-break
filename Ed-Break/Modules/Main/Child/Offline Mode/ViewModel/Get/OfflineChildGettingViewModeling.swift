//
//  OfflineChildGettingViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 08.08.23.
//

import SwiftUI

protocol OfflineChildGettingViewModeling: ObservableObject {
    
    var isLoading: Bool { get set }
    var contentModel: OfflineChildModel? { get set }
    var remindingMinutes: Int { get set }
    var shieldSeconds: Int { get set }
    var progress: Double { get set }
    var shouldShowExercises: Bool  { get set }
    var isActiveWrongAnswersBlock: Bool { get }
    var doingSubject: OfflineSubjectModel? { get }
    
    func getSubjects()
}
