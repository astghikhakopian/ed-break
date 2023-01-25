//
//  ShieldConfigurationExtension.swift
//  ShieldConfigurationExtension
//
//  Created by Astghik Hakopian on 19.12.22.
//

import ManagedSettings
import ManagedSettingsUI
import SwiftUI

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        ShieldConfiguration(
            icon: UIImage(named: "logo"),
            title: ShieldConfiguration.Label(text: "Ed-Break", color: .label),
            subtitle: ShieldConfiguration.Label(text: "You cannot use this app because you didn’t complete your exercise goal", color: .label),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Do Exercises", color: .white),
            primaryButtonBackgroundColor: UIColor(Color.primaryPurple)
            // secondaryButtonLabel: ShieldConfiguration.Label(text: "Ask for access", color: UIColor(Color.primaryPurple))
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration(
            icon: UIImage(named: "logo"),
            title: ShieldConfiguration.Label(text: "Ed-Break", color: .label),
            subtitle: ShieldConfiguration.Label(text: "You cannot use this app because you didn’t complete your exercise goal", color: .label),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Do Exercises", color: .white),
            primaryButtonBackgroundColor: UIColor(Color.primaryPurple)
            // secondaryButtonLabel: ShieldConfiguration.Label(text: "Ask for access", color: UIColor(Color.primaryPurple))
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration(
            icon: UIImage(named: "logo"),
            title: ShieldConfiguration.Label(text: "Ed-Break", color: .label),
            subtitle: ShieldConfiguration.Label(text: "You cannot use this app because you didn’t complete your exercise goal", color: .label),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Do Exercises", color: .white),
            primaryButtonBackgroundColor: UIColor(Color.primaryPurple)
            // secondaryButtonLabel: ShieldConfiguration.Label(text: "Ask for access", color: UIColor(Color.primaryPurple))
        )
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration(
            icon: UIImage(named: "logo"),
            title: ShieldConfiguration.Label(text: "Ed-Break", color: .label),
            subtitle: ShieldConfiguration.Label(text: "You cannot use this app because you didn’t complete your exercise goal", color: .label),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Do Exercises", color: .white),
            primaryButtonBackgroundColor: UIColor(Color.primaryPurple)
            // secondaryButtonLabel: ShieldConfiguration.Label(text: "Ask for access", color: UIColor(Color.primaryPurple))
        )
    }
}
