//
//  ChildDetailsViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import SwiftUI

protocol ChildDetailsViewModeling: ObservableObject {
    
    var children: [ChildDetailsModel] { get set }
    var grades: [Grade] { get set }
    
    var isContentValid: Bool { get set }
    var isLoading: Bool { get set }
    
    func addAnotherChild()
    func appendChildren()
}
