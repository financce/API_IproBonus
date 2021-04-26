//
//  NetworkError.swift
//  AppExample
//
//  Created by slava on 26/04/2021.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case unknown, apiError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason):
            return reason
        }
    }
}
