//
//  CoachingViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 31.10.22.
//

import SwiftUI

protocol CoachingViewModeling: ObservableObject {
    
    var children: PagingModel<ChildModel> { get }
    var isLoading: Bool { get set }
    var selectedPeriod: TimePeriod { get set }
    var timePeriodDatasource: [TimePeriod] { get }
    
    func getCoachingChildren()
}
