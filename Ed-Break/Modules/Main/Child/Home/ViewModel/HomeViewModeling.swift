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
    
    func getSubjects()
}
