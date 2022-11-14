//
//  ChildrenViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import SwiftUI

protocol ChildrenViewModeling: ObservableObject {
    
    var children: PagingModel<ChildModel> { get }
    var coachingChildren: [CoachingChildModel] { get }
    var isLoading: Bool { get set }
    var connectedChildren: [ChildModel] { get set }
    var selectedPeriod: TimePeriod { get set }
    var timePeriodDatasource: [TimePeriod] { get }
    
    func getChildren()
    func pairChild(id: Int, deviceToken: String, compleated: @escaping (Bool)->())
}
