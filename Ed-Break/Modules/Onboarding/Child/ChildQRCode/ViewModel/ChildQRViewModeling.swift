//
//  ChildQRViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 29.10.22.
//

import SwiftUI

protocol ChildQRViewModeling: ObservableObject {
    
    var isLoading: Bool { get set }
    
    func checkConnection(compleated: @escaping (Bool)->())
}
