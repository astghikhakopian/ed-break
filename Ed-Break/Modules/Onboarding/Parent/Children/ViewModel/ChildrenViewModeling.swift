//
//  ChildrenViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import SwiftUI
import FamilyControls

protocol ChildrenViewModeling: ObservableObject {
    
    var children: PagingModel<ChildModel> { get }
    var coachingChildren: [CoachingChildModel] { get }
    var isLoading: Bool { get set }
    var isContentValid: Bool { get set }
    var connectedChildren: [ChildModel] { get set }
    var selectedPeriod: TimePeriod { get set }
    var timePeriodDatasource: [TimePeriod] { get set }
    
    func getChildren()
    func addRestrictions(childId: Int, selection: FamilyActivitySelection)
    func getCoachingChildren()
    func pairChild(id: Int, deviceToken: String, compleated: @escaping (Bool)->())
    func refreshToken(completion: @escaping (Bool) -> Void)
}
