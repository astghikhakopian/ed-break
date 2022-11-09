//
//  ChildProfileViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 11.10.22.
//

import SwiftUI

protocol ChildProfileViewModeling: ObservableObject, Identifiable {
    
    var child: ChildModel { get }
    var datasource: [TimePeriod] { get }
    var detailsInfo: ChildProfileModel { get set }
    var isLoading: Bool { get set }
    var selectedEducationPeriod: TimePeriod { get set }
    var selectedActivityPeriod: TimePeriod { get set }
    
    func getChildDetails()
}
