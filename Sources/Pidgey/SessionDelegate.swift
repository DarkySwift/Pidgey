//
//  SessionDelegate.swift
//  Pidgey
//
//  Created by Carlos Duclos on 5/28/18.
//

import Foundation

/// Responsible for handling all delegate callbacks for the underlying session.
open class SessionDelegate: NSObject {
    
    // MARK: URLSessionDelegate Overrides
    
    open var sessionDidBecomeInvalidWithError: ((URLSession, Error?) -> Void)?
    
    open var sessionDidReceiveAuthenticationChallenge: ((URLSession, URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?)))?
    
    open var sessionDidFinishEventsForBackgroundSession: ((URLSession) -> Void)?
    
    // MARK: URLSessionTaskDelegate Overrides
    
    open var taskDidComplete: ((URLSession, URLSessionTask, Error?) -> Void)?
    
    // MARK: URLSessionDataDelegate Overrides
    
    open var dataTaskDidReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?
    
    open var dataTaskDidReceiveResponseWithCompletion: ((URLSession, URLSessionDataTask, URLResponse, @escaping (URLSession.ResponseDisposition) -> Void) -> Void)?
    
}

extension SessionDelegate: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        sessionDidBecomeInvalidWithError?(session, error)
    }
    
}

extension SessionDelegate: URLSessionTaskDelegate {
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
}
