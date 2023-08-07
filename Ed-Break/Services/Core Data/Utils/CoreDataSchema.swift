//
//  CoreDataSchema.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.08.23.
//

enum Schema {
    
    enum OfflineChild: String {
        case id
    }
}

import SwiftUI

extension EnvironmentValues {
    
    var childProviderKey: OfflineChildProvideerProtocol? {
        get { self[ChildProviderKey.self] }
        set { self[ChildProviderKey.self] = newValue }
    }
}


// MARK: - Enviroment Keys

private struct ChildProviderKey: EnvironmentKey {
    
    static let defaultValue: OfflineChildProvideerProtocol? = nil
}

