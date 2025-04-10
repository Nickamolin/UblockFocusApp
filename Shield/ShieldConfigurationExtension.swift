//
//  ShieldConfigurationExtension.swift
//  Shield
//
//  Created by Nicholas Gamolin on 4/10/25.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        return ShieldConfiguration(backgroundBlurStyle: .dark, backgroundColor: .black, icon: UIImage(systemName: "exclamationmark.lock.fill")!.withTintColor(.white), title: ShieldConfiguration.Label(text:"Narrow Your Focus", color: .blue), subtitle: ShieldConfiguration.Label(text:"Look at your to-do's.", color: .white), primaryButtonLabel: ShieldConfiguration.Label(text:"Close", color: .white), primaryButtonBackgroundColor: .blue)
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}

class MyShieldActionExtension: ShieldActionDelegate {
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.defer)
        case .secondaryButtonPressed:
            completionHandler(.defer)
        @unknown default:
            fatalError()
        }
    }
}
