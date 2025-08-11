//
//  TestError.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation

enum TestError: Error, LocalizedError {
    case mockError
    case timeoutError
    case dataError

    var errorDescription: String? {
        switch self {
        case .mockError:
            return "Mock error for testing"
        case .timeoutError:
            return "Test timeout error"
        case .dataError:
            return "Test data error"
        }
    }
}
