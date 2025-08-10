//
//  AuthenticationManager.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import LocalAuthentication

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var hasSetupPIN = false
    @Published var biometricType: BiometricType = .none
    @Published var isBiometricEnabled = false
    @Published var showingPINSetup = false
    @Published var showingAuthentication = false
    @Published var isAuthenticating = false

    private let keychain = KeychainHelper()

    init() {
        checkBiometricAvailability()
        checkPINSetup()
        loadSettings()
    }

    func authenticateWithBiometric() async -> Bool {
        // Prevent multiple simultaneous authentications
        guard !isAuthenticating else {
            return false
        }

        guard biometricType != .none else {
            return false
        }

        let context = LAContext()
        context.localizedCancelTitle = "Use PIN Instead"
        context.localizedFallbackTitle = "Enter PIN"

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            await MainActor.run {
                self.biometricType = .none
            }
            return false
        }

        await MainActor.run {
            self.isAuthenticating = true
        }

        defer {
            Task { @MainActor in
                self.isAuthenticating = false
            }
        }

        do {
            let result = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Authenticate to access your TV Shows"
            )

            if result {
                await MainActor.run {
                    self.isAuthenticated = true
                }
            }
            return result

        } catch let error as LAError {
            switch error.code {
            case .userCancel, .userFallback, .systemCancel:
                return false
            case .biometryNotAvailable:
                await MainActor.run {
                    self.biometricType = .none
                    self.isBiometricEnabled = false
                }
                return false
            case .biometryNotEnrolled:
                return false
            case .passcodeNotSet:
                return false
            default:
                return false
            }
        } catch {
            return false
        }
    }

    func authenticateWithPIN(_ pin: String) -> Bool {
        guard let storedPIN = keychain.getPIN() else {
            return false
        }

        if pin == storedPIN {
            isAuthenticated = true
            return true
        }
        return false
    }

    func setupPIN(_ pin: String) -> Bool {
        let success = keychain.savePIN(pin)
        if success {
            hasSetupPIN = true
            showingPINSetup = false
        }
        return success
    }

    func removePIN() {
        keychain.deletePIN()
        hasSetupPIN = false
        isBiometricEnabled = false
        UserDefaults.standard.removeObject(forKey: "biometric_enabled")
    }

    func toggleBiometric() {
        // Don't allow enabling if requirements not met
        let newValue = !isBiometricEnabled
        if newValue && (biometricType == .none || !hasSetupPIN) {
            return
        }

        isBiometricEnabled = newValue
        UserDefaults.standard.set(isBiometricEnabled, forKey: "biometric_enabled")
    }

    private func checkBiometricAvailability() {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            biometricType = .none
            return
        }

        switch context.biometryType {
        case .touchID:
            biometricType = .touchID
        case .faceID:
            biometricType = .faceID
        default:
            biometricType = .none
        }
    }

    private func checkPINSetup() {
        hasSetupPIN = keychain.getPIN() != nil
    }

    private func loadSettings() {
        isBiometricEnabled = UserDefaults.standard.bool(forKey: "biometric_enabled")

        // Disable biometric if not available or no PIN
        if biometricType == .none || !hasSetupPIN {
            isBiometricEnabled = false
            UserDefaults.standard.set(false, forKey: "biometric_enabled")
        }
    }
}
