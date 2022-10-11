//
//  ChildProfileViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 11.10.22.
//

import SwiftUI

protocol ChildProfileViewModeling: ObservableObject {
    
    var child: ChildModel { get }
    var isLoading: Bool { get set }
    var connectedChildren: [ChildModel] { get set }
    
    func getChildDetails()
}
