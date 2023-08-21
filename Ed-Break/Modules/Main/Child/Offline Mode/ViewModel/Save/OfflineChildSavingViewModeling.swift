//
//  OfflineChildSavingViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.08.23.
//

import SwiftUI

protocol OfflineChildSavingViewModeling: ObservableObject {
    
    var isLoading: Bool { get set }
    var onError: Error? { get set }
    var onSuccess: Bool? { get set }
    
    func updateOfflineChild()
}
