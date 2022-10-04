//
//  FamilySharingViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import SwiftUI

protocol FamilySharingViewModeling: ObservableObject {
    
    var isLoading: Bool { get set }
    
    func addParent()
}
