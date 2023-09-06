//
//  ChildSignInView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 20.10.22.
//

import SwiftUI
import FamilyControls

struct ChildSignInView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var error: FamilyControlsError? = nil
    @State private var isAlertPresenting: Bool = false
    
    private let cornerRadius = 12.0
    private let padding = 36.0
    private let gap = 20.0
    
    var body: some View {
        
        MainBackground(
            title: "onboarding.childSignIn.title",
            withNavbar: true) {
                ZStack(alignment: .leading) {
                    Color.primaryCellBackground
                        .cornerRadius(cornerRadius)
                        .shadow(color: .shadow, radius: 40, x: 0, y: 20)
                    
                    VStack(spacing: gap) {
                        Text("onboarding.childSignIn.description")
                            .font(.appHeadline)
                            .foregroundColor(.primaryText)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        ZStack {
                            Color.primaryPurple.opacity(0.05)
                            CancelButton(action: {
                                
                                Task {
                                    if #available(iOS 16.0, *) {
                                        do {
                                            try await AuthorizationCenter.shared.requestAuthorization(for: .child)
                                            DispatchQueue.main.async {
                                                appState.moveToChildQR = true
                                            }
                                        } catch {
                                            self.error = getFamilyControlsError(for: error)
                                            self.isAlertPresenting = true
                                        }
                                        
                                    } else {
                                        AuthorizationCenter.shared.requestAuthorization { result in
                                            switch result {
                                            case .success:
                                                DispatchQueue.main.async {
                                                    appState.moveToChildQR = true
                                                }
                                            case .failure(let error):
                                                self.error = getFamilyControlsError(for: error)
                                                self.isAlertPresenting = true
                                                print("Error for Family Controls: \(error)")
                                                
                                            }
                                        }
                                    }
                                }
                            },
                                         title: "onboarding.childSignIn.action",
                                         color: .primaryPurple,
                                         isContentValid: .constant(true)
                            )
                        }
                        .cornerRadius(cornerRadius)
                    }.padding(padding)
                }
                .alert(
                    "common.error",
                    isPresented: $isAlertPresenting, actions: { },
                    message: {
                        if let error = error {
                            Text(getDescription(for: error))
                        } else {
                            Text("")
                        }
                    }
                )
            }
    }
    
    private func getDescription(for error: FamilyControlsError) -> String {
        switch error {
        case .restricted:
            return "A restriction prevents your app from using Family Controls on this device."
        case .unavailable:
            return "The system failed to set up the Family Control framework."
        case .invalidAccountType:
            return "The device isn’t signed into a valid iCloud account."
        case .invalidArgument:
            return "The method’s arguments are invalid."
        case .authorizationConflict:
            return "Another authorized app already provides parental controls."
        case .authorizationCanceled:
            return "The parent or guardian canceled a request for authorization."
        case .networkError:
            return "The device must be connected to the network in order to enroll with parental controls."
        case .authenticationMethodUnavailable:
            return "The device must have a passcode set in order for an individual to enroll with parental controls."
        @unknown default:
            return error.localizedDescription
        }
    }
    
    private func getFamilyControlsError(for error: Error) -> FamilyControlsError {
        if let error = error as? FamilyControlsError {
            return error
        } else {
            guard let number = Int(error.localizedDescription.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
                return .invalidAccountType
            }
            switch number {
            case 0: return  .restricted
            case 1: return  .unavailable
            case 2: return  .invalidAccountType
            case 3: return  .invalidArgument
            case 4: return  .authorizationConflict
            case 5: return  .authorizationCanceled
            case 6: return  .networkError
            case 7: return  .invalidAccountType
            default: return .invalidAccountType
            }
        }
    }
}

struct ChildSignInView_Previews: PreviewProvider {
    static var previews: some View {
        ChildSignInView()
    }
}
