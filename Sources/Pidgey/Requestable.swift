//
//  Request.swift
//  Pidgey
//
//  Created by Carlos Duclos on 6/2/18.
//

import Foundation

/// HTTP method definitions.
///
/// See https://tools.ietf.org/html/rfc7231#section-4.3
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

/// A dictionary of headers to apply to a `URLRequest`.
public typealias HTTPHeaders = [String: String]

public protocol Requestable: URLRequestConvertible {
    
    associatedtype Response: Decodable
    
    typealias ProgressHandler = (Progress) -> Void
    
    var method: HTTPMethod { get }
    var url: URL { get }
    var parameterData: Data? { get }
    var encoding: ParameterEncoding { get }
}

public extension Requestable {
    
    var method: HTTPMethod { return .get }
    var parameterData: Data? { return nil }
    var encoding: ParameterEncoding { return JSONEncoding.default }
}

public extension Requestable {
    
    func asURLRequest() throws -> URLRequest {
        let urlRequest = try URLRequest(url: url, method: method)
        return urlRequest
    }
}

public protocol EncodableRequestable: Requestable, Encodable {
    
    associatedtype EncodableParameters: Encodable
    
    var encodableParameters: EncodableParameters { get }
}

public extension EncodableRequestable {
    
    func asURLRequest() throws -> URLRequest {
        let urlRequest = try URLRequest(url: url, method: method)
        return try encoding.encode(urlRequest, encodableParameters: encodableParameters)
    }
    
    public func encode(to encoder: Encoder) throws {
        try encodableParameters.encode(to: encoder)
    }
    
    public var parameterData: Data? {
        return try? JSONCoding.encoder.encode(encodableParameters)
    }
}
