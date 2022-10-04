//
//  ChildDetailsViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import SwiftUI

protocol ChildDetailsViewModeling: ObservableObject {
    
    var image: UIImage { get set }
    var childName: String { get set }
    var grade: Grade { get set }
    var grades: [Grade] { get set }
    
    var isContentValid: Bool { get set }
    var isLoading: Bool { get set }
    
    func addChild(shouldShowLoading: Bool)
    func prepareForNewChild()
}
