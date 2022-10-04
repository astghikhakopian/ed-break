//
//  ChildrenViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import SwiftUI

protocol ChildrenViewModeling: ObservableObject {
    
    var children: PagingModel<ChildModel> { get }
    
    func getChildren()
}
