//
//  PINEntryView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct PINEntryView: View {
    @Binding var pin: String
    let maxLength: Int
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                ForEach(0..<maxLength, id: \.self) { index in
                    Circle()
                        .fill(index < pin.count ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 20, height: 20)
                }
            }

            // Hidden TextField for input
            TextField("", text: $pin)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0)
                .frame(height: 0)
                .onChange(of: pin) { oldValue, newValue in
                    // Limit to numbers only and max length
                    let filtered = String(newValue.prefix(maxLength).filter { $0.isNumber })
                    if filtered != newValue {
                        pin = filtered
                    }
                }

            // Invisible button to trigger focus
            Button("") {
                isFocused = true
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
        }
        .onAppear {
            isFocused = true
        }
        .onTapGesture {
            isFocused = true
        }
    }
}
