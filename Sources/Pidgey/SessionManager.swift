//
//  Session.swift
//  Pidgey
//
//  Created by Carlos Duclos on 5/28/18.
//

import Foundation

open class SessionManager {
    
    open let delegate: SessionDelegate
    open let session: URLSession
    
    static let `default`: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        //        configuration.httpAdditionalHeaders =
        return SessionManager(configuration: configuration)
    }()
    
    let queue = DispatchQueue(label: "com.darkyswift.pidgey.sessionmanager." + UUID().uuidString)
    
    init(configuration: URLSessionConfiguration = .default, delegate: SessionDelegate = SessionDelegate()) {

        self.delegate = delegate
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }
    
    /// Creates a `DataRequest` to retrieve the contents of the specified `url`, `method`, `parameters`, `encoding` and `headers`.
    ///
    /// - parameter url: The URL.
    /// - parameter method: The HTTP method. `.get` by default.
    /// - parameter parametersData: The parameters. `nil` by default.
    /// - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `DataRequest`.
    open func request(_ url: URLConvertible, method: HTTP.Method = .get, parametersData: Data? = nil,
                      encoding: ParameterEncoding = URLEncoding.default, headers: HTTP.Headers? = nil) {
        
        
    }
    
    open func request<R: Requestable>(_ request: R, completion: @escaping (HTTP.Result<R.Response>) -> Void) {
        
        guard let urlRequest = try? request.asURLRequest() else {
            completion(.error(.invalidURLRequest))
            return
        }
        
        queue.sync { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.session.dataTask(with: urlRequest)
        }
    }
    
}
