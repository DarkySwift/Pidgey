//
//  RequestOperation.swift
//  Pidgey
//
//  Created by Carlos Duclos on 6/2/18.
//

import Foundation

public class RequestOperation: Operation {
    
    typealias ResponseHandler = (Response<Encodable>, Error) -> Void
    
    // MARK: - Properties
    
    var url: URLConvertible
    var method: HTTPMethod
    var parametersData: Data?
    var encoding: ParameterEncoding
    var headers: HTTPHeaders?
    var responseHandler: ResponseHandler
    
    // MARK: - Initializers
    
    init(url: URLConvertible, method: HTTPMethod, parametersData: Data?, encoding: ParameterEncoding, headers: HTTPHeaders?, responseHandler: @escaping ResponseHandler) {
        self.url = url
        self.method = method
        self.parametersData = parametersData
        self.encoding = encoding
        self.headers = headers
        self.responseHandler = responseHandler
    }
    
    func execute() {
        
//        guard isCancelled == false else { return }
        
//        let startDate = Date()
//        
//        SessionManager.default.request(url, method: method, parametersData: parametersData, encoding: encoding, headers: headers)
        
    }
    
}
