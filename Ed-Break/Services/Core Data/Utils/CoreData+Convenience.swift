//
//  CoreData+Convenience.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.08.23.
//

import UIKit
import CoreData

// MARK: - Saving Contexts

enum ContextSaveContextualInfo: String {
    case addContact = "adding a offilne child"
    case updateContact = "updating a offilne child"
    case deleteContact = "deleting a offilne child"
}

extension NSManagedObjectContext {
    
    private func handleSavingError(_ error: Error, contextualInfo: ContextSaveContextualInfo) {
        print("Context saving error: \(error)")
        
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.delegate?.window,
                let viewController = window?.rootViewController else { return }
            
            let message = "Failed to save the context when \(contextualInfo.rawValue)."
            
            // Append message to existing alert if present
            if let currentAlert = viewController.presentedViewController as? UIAlertController {
                currentAlert.message = (currentAlert.message ?? "") + "\n\n\(message)"
                return
            }
            
            // Otherwise present a new alert
            let alert = UIAlertController(title: "Core Data Saving Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }
    
    func save(with contextualInfo: ContextSaveContextualInfo) {
        guard hasChanges else { return }
        do {
            try save()
        } catch {
            handleSavingError(error, contextualInfo: contextualInfo)
        }
    }
}

extension OfflineChildMO {
    
    static let entityName = "OfflineChildMO"
}
