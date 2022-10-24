//
//  ParentSettingsViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

import SwiftUI

protocol ParentSettingsViewModeling: ObservableObject {
    
    var isLoading: Bool { get set }
    
    func deleteParent(completion: @escaping ()->())
}
