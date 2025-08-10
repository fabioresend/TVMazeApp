//
//  PINSetupView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct PINSetupView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var pin = ""
    @State private var confirmPin = ""
    @State private var isConfirming = false
    @State private var showingError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                VStack(spacing: 16) {
                    Image(systemName: "lock.shield")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)

                    Text(isConfirming ? "Confirm PIN" : "Set up PIN")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(isConfirming ? "Re-enter your 4-digit PIN" : "Create a 4-digit PIN to secure your app")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                PINEntryView(pin: isConfirming ? $confirmPin : $pin, maxLength: 4)
                    .onChange(of: pin) { oldValue, newValue in
                        if newValue.count == 4 && !isConfirming {
                            withAnimation {
                                isConfirming = true
                            }
                        }
                    }
                    .onChange(of: confirmPin) { oldValue, newValue in
                        if newValue.count == 4 && isConfirming {
                            setupPIN()
                        }
                    }

                if isConfirming {
                    Button("Back") {
                        withAnimation {
                            isConfirming = false
                            confirmPin = ""
                        }
                    }
                    .foregroundColor(.blue)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("PIN Setup")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $showingError) {
                Button("OK") {
                    pin = ""
                    confirmPin = ""
                    isConfirming = false
                }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func setupPIN() {
        guard pin == confirmPin else {
            errorMessage = "PINs do not match"
            showingError = true
            return
        }

        let success = authManager.setupPIN(pin)
        if !success {
            errorMessage = "Failed to save PIN"
            showingError = true
        }
    }
}
