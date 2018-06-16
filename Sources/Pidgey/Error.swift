//
//  Error.swift
//  Pidgey
//
//  Created by Carlos Duclos on 5/27/18.
//  Copyright © 2018 DarkySwift. All rights reserved.
//

import Foundation

public extension Pidgey {
    
    public enum Error: Swift.Error {
        
        case invalidURL(url: URLConvertible)
        case parameterEncodingFailed
    }
}

public extension Pidgey.Error {
    
    /// The underlying reason the parameter encoding error occurred.
    ///
    /// - missingURL:                 The URL request did not have a URL to encode.
    /// - jsonEncodingFailed:         JSON serialization failed with an underlying system error during the
    ///                               encoding process.
    /// - propertyListEncodingFailed: Property list serialization failed with an underlying system error during
    ///
    public enum ParameterEncodingFailureReason {
        
        case missingURL
        case jsonEncodingFailed(error: Error)
        case propertyListEncodingFailed(error: Error)
    }
}

extension Pidgey.Error.ParameterEncodingFailureReason: CustomDebugStringConvertible {
    
    /// Returns a debuggable description of the reason.
    public var debugDescription: String {
        switch self {
        case .missingURL: return "URL request to encode was missing a URL"
        case .jsonEncodingFailed(let error): return "JSON could not be encoded because of error: \(error.localizedDescription)"
        case .propertyListEncodingFailed(let error): return "PropertyList could not be encoded because of error: \(error.localizedDescription)"
        }
    }
    
}

// MARK: - Convenience Error Booleans

public extension Pidgey.Error {
    
    /// Returns whether the Error is an invalidURL error.
    public var isInvalidURLError: Bool {
        guard case .invalidURL = self else { return false }
        return true
    }
    
    /// Returns whether the Error is an parameterEncodingFailed error.
    public var isParameterEncodingFailedError: Bool {
        guard case .parameterEncodingFailed = self else { return false }
        return true
    }
}

// MARK: - Convenience Properties

public extension Pidgey.Error {

    /// The `URLConvertible` associated with the error.
    public var urlConvertible: URLConvertible? {
        switch self {
        case .invalidURL(let url): return url
        default: return nil
        }
    }
}

// MARK: - Error Descriptions

extension Pidgey.Error: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL(let url): return "Invalid url: \(url)"
        case .parameterEncodingFailed: return "Invalid encodable data"
        }
    }
    
}
