//
//  AuthenticationView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID

    var displayName: String {
        switch self {
        case .touchID: return "Touch ID"
        case .faceID: return "Face ID"
        default: return "Unavailable"
        }
    }

    var icon: String {
        switch self {
        case .touchID: return "touchid"
        case .faceID: return "faceid"
        default: return "xmark.circle"
        }
    }
}

struct AuthenticationView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var enteredPIN = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var attemptedBiometric = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                // App Logo/Icon
                VStack(spacing: 16) {
                    Image(systemName: "tv")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)

                    Text("TVMazeApp")
                        .font(.title)
                        .fontWeight(.bold)
                }

                VStack(spacing: 24) {
                    // Biometric Authentication
                    if authManager.biometricType != .none && authManager.isBiometricEnabled {
                        Button(action: {
                            Task {
                                await authenticateWithBiometric()
                            }
                        }) {
                            HStack {
                                if authManager.isAuthenticating {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .tint(.white)
                                } else {
                                    Image(systemName: authManager.biometricType.icon)
                                        .font(.title2)
                                }
                                Text(authManager.isAuthenticating ? "Authenticating..." : "Unlock with \(authManager.biometricType.displayName)")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(authManager.isAuthenticating ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(authManager.isAuthenticating)
                    }

                    // PIN Entry
                    if authManager.hasSetupPIN {
                        VStack(spacing: 16) {
                            Text("Enter PIN")
                                .font(.headline)

                            PINEntryView(pin: $enteredPIN, maxLength: 4)
                                .onChange(of: enteredPIN) { oldValue, newValue in
                                    if newValue.count == 4 {
                                        authenticateWithPIN()
                                    }
                                }
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            .alert("Authentication Failed", isPresented: $showingError) {
                Button("OK") {
                    enteredPIN = ""
                }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                // Auto-trigger biometric if available, enabled, and not attempted yet
                if authManager.biometricType != .none &&
                    authManager.isBiometricEnabled &&
                    !attemptedBiometric &&
                    !authManager.isAuthenticating {
                    attemptedBiometric = true
                    Task {
                        // Small delay to ensure UI is ready
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        await authenticateWithBiometric()
                    }
                }
            }
        }
    }

    private func authenticateWithBiometric() async {
        let success = await authManager.authenticateWithBiometric()
        if !success && !authManager.isAuthenticated {
            await MainActor.run {
                errorMessage = "Biometric authentication failed or was cancelled"
                showingError = true
            }
        }
    }

    private func authenticateWithPIN() {
        let success = authManager.authenticateWithPIN(enteredPIN)
        if !success {
            errorMessage = "Incorrect PIN"
            showingError = true
            enteredPIN = ""
        }
    }
}
