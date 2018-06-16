//
//  Encoding.swift
//  Pidgey
//
//  Created by Carlos Duclos on 6/2/18.
//

import Foundation

/// A type used to define how a set of parameters are applied to a `URLRequest`.
public protocol ParameterEncoding {
    
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    func encode<E: Encodable>(_ urlConvertible: URLRequestConvertible, encodableParameters: E) throws -> URLRequest
}

public struct URLEncoding: ParameterEncoding {
    
    // MARK: Helper Types
    
    /// Defines whether the url-encoded query string is applied to the existing query string or HTTP body of the
    /// resulting URL request.
    ///
    /// - methodDependent: Applies encoded query string result to existing query string for `GET`, `HEAD` and `DELETE`
    ///                    requests and sets as the HTTP body for requests with any other HTTP method.
    /// - queryString:     Sets or appends encoded query string result to existing query string.
    /// - httpBody:        Sets encoded query string result as the HTTP body of the URL request.
    public enum Destination {
        case methodDependent, queryString, httpBody
    }
    
    /// Configures how `Array` parameters are encoded.
    ///
    /// - brackets:        An empty set of square brackets is appended to the key for every value.
    ///                    This is the default behavior.
    /// - noBrackets:      No brackets are appended. The key is encoded as is.
    public enum ArrayEncoding {
        case brackets, noBrackets
        
        func encode(key: String) -> String {
            switch self {
            case .brackets:
                return "\(key)[]"
            case .noBrackets:
                return key
            }
        }
    }
    
    /// Configures how `Bool` parameters are encoded.
    ///
    /// - numeric:         Encode `true` as `1` and `false` as `0`. This is the default behavior.
    /// - literal:         Encode `true` and `false` as string literals.
    public enum BoolEncoding {
        case numeric, literal
        
        func encode(value: Bool) -> String {
            switch self {
            case .numeric:
                return value ? "1" : "0"
            case .literal:
                return value ? "true" : "false"
            }
        }
    }
    
    // MARK: Properties
    
    /// Returns a default `URLEncoding` instance.
    public static var `default`: URLEncoding { return URLEncoding() }
    
    /// Returns a `URLEncoding` instance with a `.methodDependent` destination.
    public static var methodDependent: URLEncoding { return URLEncoding() }
    
    /// Returns a `URLEncoding` instance with a `.queryString` destination.
    public static var queryString: URLEncoding { return URLEncoding(destination: .queryString) }
    
    /// Returns a `URLEncoding` instance with an `.httpBody` destination.
    public static var httpBody: URLEncoding { return URLEncoding(destination: .httpBody) }
    
    /// The destination defining where the encoded query string is to be applied to the URL request.
    public let destination: Destination
    
    /// The encoding to use for `Array` parameters.
    public let arrayEncoding: ArrayEncoding
    
    /// The encoding to use for `Bool` parameters.
    public let boolEncoding: BoolEncoding
    
    // MARK: Initialization
    
    /// Creates a `URLEncoding` instance using the specified destination.
    ///
    /// - parameter destination: The destination defining where the encoded query string is to be applied.
    /// - parameter arrayEncoding: The encoding to use for `Array` parameters.
    /// - parameter boolEncoding: The encoding to use for `Bool` parameters.
    ///
    /// - returns: The new `URLEncoding` instance.
    public init(destination: Destination = .methodDependent, arrayEncoding: ArrayEncoding = .brackets, boolEncoding: BoolEncoding = .numeric) {
        self.destination = destination
        self.arrayEncoding = arrayEncoding
        self.boolEncoding = boolEncoding
    }
    
    public func encode<E: Encodable>(_ urlConvertible: URLRequestConvertible, encodableParameters: E) throws -> URLRequest {
        // TODO
        return urlConvertible.urlRequest!
    }
    
}

public struct JSONEncoding: ParameterEncoding {
    
    // MARK: Properties
    
    /// Returns a `JSONEncoding` instance with default writing options.
    public static var `default`: JSONEncoding { return JSONEncoding() }
    
    /// Returns a `JSONEncoding` instance with `.prettyPrinted` writing options.
    public static var prettyPrinted: JSONEncoding { return JSONEncoding(options: .prettyPrinted) }
    
    /// The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions
    
    // MARK: Initialization
    
    /// Creates a `JSONEncoding` instance using the specified options.
    ///
    /// - parameter options: The options for writing the parameters as JSON data.
    ///
    /// - returns: The new `JSONEncoding` instance.
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    // MARK: Encoding
    
    /// Creates a URL request by encoding the JSON object and setting the resulting data on the HTTP body.
    ///
    /// - parameter request: The request with the encoded parameter data..
    ///
    /// - returns: The encoded URLRequest.
    public func encode<E: Encodable>(_ urlConvertible: URLRequestConvertible, encodableParameters: E) throws -> URLRequest {
        
        guard var urlRequest = urlConvertible.urlRequest else { throw Pidgey.Error.parameterEncodingFailed }

        guard let encodedParameters = try? JSONCoding.encoder.encode(encodableParameters) else { throw Pidgey.Error.parameterEncodingFailed }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = encodedParameters
        return urlRequest
    }
}

public struct JSONCoding {
    
    public static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .default
        return decoder
    }
    
    public static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .default
        return encoder
    }
}

public extension JSONDecoder.DateDecodingStrategy {
    
    public static let `default`: JSONDecoder.DateDecodingStrategy = .custom(decode)
    
    private static func decode(_ decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        guard let date = Date(string: dateString) else {
            throw DecodingError.typeMismatch(Date.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid date string"))
        }
        
        return date
    }
}

public extension JSONEncoder.DateEncodingStrategy {
    
    public static let `default`: JSONEncoder.DateEncodingStrategy = .custom(encode)
    
    private static func encode(date: Date, _ encode: Encoder) throws {
        
    }
}
