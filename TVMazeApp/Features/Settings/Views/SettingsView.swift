//
//  SettingsView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            List {
                authenticationSection
                securityInfoSection
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $viewModel.showingPINSetup) {
                PINSetupView(authManager: viewModel.authManager)
            }
            .alert("Remove PIN", isPresented: $viewModel.showingPINRemoval) {
                Button("Cancel", role: .cancel) { }
                Button("Remove", role: .destructive) {
                    viewModel.removePIN()
                }
            } message: {
                Text("Are you sure you want to remove your PIN? This will also disable biometric authentication.")
            }
            .alert("Biometric Error", isPresented: $viewModel.showingBiometricError) {
                Button("OK") { }
            } message: {
                Text(viewModel.biometricErrorMessage)
            }
        }
    }

    // MARK: - View Components
    private var authenticationSection: some View {
        Section("Authentication") {
            pinCodeRow

            if viewModel.biometricType != .none {
                biometricRow
            } else {
                biometricUnavailableRow
            }
        }
    }

    private var pinCodeRow: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(.blue)

            VStack(alignment: .leading) {
                Text("PIN Code")
                    .font(.headline)
                Text(viewModel.pinStatusText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if viewModel.hasSetupPIN {
                Button("Remove") {
                    viewModel.showPINRemovalAlert()
                }
                .foregroundColor(.red)
            } else {
                Button("Setup") {
                    viewModel.setupPIN()
                }
            }
        }
    }

    private var biometricRow: some View {
        HStack {
            Image(systemName: viewModel.biometricTypeIcon)
                .foregroundColor(viewModel.biometricIconColor)

            VStack(alignment: .leading) {
                Text(viewModel.biometricTypeDisplayName)
                    .font(.headline)
                    .foregroundColor(viewModel.biometricTextColor)
                Text(viewModel.biometricSubtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Toggle("", isOn: viewModel.biometricBinding())
                .disabled(!viewModel.canUseBiometric || viewModel.isAuthenticating)
        }
    }

    private var biometricUnavailableRow: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.orange)

            VStack(alignment: .leading) {
                Text("Biometric Authentication")
                    .font(.headline)
                Text("Not available on this device")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var securityInfoSection: some View {
        Section("Security Info") {
            Label("Your PIN is securely stored in the device keychain", systemImage: "info.circle")
                .font(.caption)
                .foregroundColor(.secondary)

            if viewModel.biometricType != .none {
                Label("Biometric data never leaves your device", systemImage: "shield.checkered")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
