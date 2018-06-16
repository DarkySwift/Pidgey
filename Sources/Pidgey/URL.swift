//
//  URLConvertible.swift
//  Pidgey
//
//  Created by Carlos Duclos on 5/27/18.
//  Copyright © 2018 DarkySwift. All rights reserved.
//

import Foundation

/// Types implementing `URLConvertible` protocol can be used to construct URLs
public protocol URLConvertible {
    
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Pidgey.Error`.
    func asUrl() throws -> URL
}

extension URL: URLConvertible {
    
    /// Returns self
    public func asUrl() throws -> URL {
        return self
    }
}

extension String: URLConvertible {
    
    /// Returns a URL that conforms to RFC 2396 or throws an `Pidgey.Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Pidgey.Error.invalidURL`.
    public func asUrl() throws -> URL {
        guard let url = URL(string: self) else { throw Pidgey.Error.invalidURL(url: self) }
        return url
    }
}

extension URLComponents: URLConvertible {
    
    /// Returns a URL that conforms to RFC 2396 or throws an `Pidgey.Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Pidgey.Error.invalidURL`.
    public func asUrl() throws -> URL {
        guard let url = self.url else { throw Pidgey.Error.invalidURL(url: self) }
        return url
    }
}

/// Types adopting the `URLRequestConvertible` protocol can be used to construct URL requests.
public protocol URLRequestConvertible {
    
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    
    /// The URL request.
    public var urlRequest: URLRequest? { return try? asURLRequest() }
}

extension URLRequest: URLRequestConvertible {
    
    /// Returns a URL request or throws if an `Error` was encountered.
    public func asURLRequest() throws -> URLRequest { return self }
}

extension URLRequest {
    
    /// Creates an instance with the specified `method`, `urlString` and `headers`.
    ///
    /// - parameter url: The URL.
    /// - parameter method: The HTTP method.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The new `URLRequest` instance.
    public init(url: URLConvertible, method: HTTP.Method, headers: HTTP.Headers? = nil) throws {
        let url = try url.asUrl()
        
        self.init(url: url)
        
        httpMethod = method.rawValue
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
    
//    public var debugDescription: String {
//        
//        let url = self.url?.absoluteString ?? "No url"
//        let 
//        
//    }
}
