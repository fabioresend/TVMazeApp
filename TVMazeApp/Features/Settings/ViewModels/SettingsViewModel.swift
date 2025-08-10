//
//  SettingsViewModel.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var showingPINRemoval = false
    @Published var showingBiometricError = false
    @Published var biometricErrorMessage = ""
    @Published var showingPINSetup = false

    let authManager: AuthenticationManager

    init(authManager: AuthenticationManager) {
        self.authManager = authManager
    }

    var canUseBiometric: Bool {
        authManager.biometricType != .none && authManager.hasSetupPIN
    }

    var biometricSubtitle: String {
        if !authManager.hasSetupPIN {
            return "Set up a PIN first"
        } else if authManager.biometricType == .none {
            return "Not available"
        } else {
            return "Use biometric authentication"
        }
    }

    var pinStatusText: String {
        authManager.hasSetupPIN ? "Enabled" : "Disabled"
    }

    var pinButtonText: String {
        authManager.hasSetupPIN ? "Remove" : "Setup"
    }

    var biometricIconColor: Color {
        canUseBiometric ? .blue : .gray
    }

    var biometricTextColor: Color {
        canUseBiometric ? .primary : .gray
    }

    // Exposed properties from AuthManager
    var hasSetupPIN: Bool {
        authManager.hasSetupPIN
    }

    var biometricType: BiometricType {
        authManager.biometricType
    }

    var biometricTypeIcon: String {
        authManager.biometricType.icon
    }

    var biometricTypeDisplayName: String {
        authManager.biometricType.displayName
    }

    var isAuthenticating: Bool {
        authManager.isAuthenticating
    }

    var isBiometricEnabled: Bool {
        authManager.isBiometricEnabled
    }

    func setupPIN() {
        showingPINSetup = true
    }

    func showPINRemovalAlert() {
        showingPINRemoval = true
    }

    func removePIN() {
        authManager.removePIN()
        showingPINRemoval = false
    }

    func handleBiometricToggle(newValue: Bool) {
        // If trying to enable but conditions not met
        if newValue && !canUseBiometric {
            if !authManager.hasSetupPIN {
                biometricErrorMessage = "Please set up a PIN first before enabling biometric authentication."
            } else {
                biometricErrorMessage = "Biometric authentication is not available on this device."
            }
            showingBiometricError = true
            return
        }

        // Only update if the change is valid
        authManager.toggleBiometric()
    }

    func biometricBinding() -> Binding<Bool> {
        Binding(
            get: { self.authManager.isBiometricEnabled },
            set: { newValue in
                self.handleBiometricToggle(newValue: newValue)
            }
        )
    }
}
