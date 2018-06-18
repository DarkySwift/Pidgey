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
    
    open var sessionDidFinishEventsForBackgroundSession: ((URLSession) -> Void)?
    open var sessionDidBecomeInvalidWithError: ((URLSession, Error?) -> Void)?
    open var sessionDidReceiveAuthenticationChallenge: ((URLSession, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    
    // MARK: URLSessionTaskDelegate Overrides
    
    open var taskDidComplete: ((URLSession, URLSessionTask, Error?) -> Void)?
    open var taskWillPerformHTTPRedirectionWithCompletion: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest, @escaping (URLRequest?) -> Void) -> Void)?
    open var taskDidReceiveChallengeWithCompletion: ((URLSession, URLSessionTask, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    open var taskNeedNewBodyStreamWithCompletion: ((URLSession, URLSessionTask, @escaping (InputStream?) -> Void) -> Void)?
    open var taskDidSendBodyData: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?
    
    // MARK: URLSessionDataDelegate Overrides
    
    open var dataTaskDidReceiveResponseWithCompletion: ((URLSession, URLSessionDataTask, URLResponse, @escaping (URLSession.ResponseDisposition) -> Void) -> Void)?
    open var dataTaskDidBecomeDownloadTask: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?
    open var dataTaskDidBecomeStreamTask: ((URLSession, URLSessionDataTask, URLSessionStreamTask) -> Void)?
    open var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?
    open var dataTaskWillCacheResponseWithCompletion: ((URLSession, URLSessionDataTask, CachedURLResponse, @escaping (CachedURLResponse?) -> Void) -> Void)?
}

extension SessionDelegate: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
        sessionDidBecomeInvalidWithError?(session, error)
        print("urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {")
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        sessionDidReceiveAuthenticationChallenge?(session, challenge, completionHandler)
        print("urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {")
    }
    
}

extension SessionDelegate: URLSessionTaskDelegate {
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        taskDidComplete?(session, task, error)
        print("urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse,
                           newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
        taskWillPerformHTTPRedirectionWithCompletion?(session, task, response, request, completionHandler)
        print("_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        taskDidReceiveChallengeWithCompletion?(session, task, challenge, completionHandler)
        print("urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask,
                           needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        
        taskNeedNewBodyStreamWithCompletion?(session, task, completionHandler)
        print("urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64,
                           totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        taskDidSendBodyData?(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
        print("urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {")
    }
}

extension SessionDelegate: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        dataTaskDidReceiveResponseWithCompletion?(session, dataTask, response, completionHandler)
        print("urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)")
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        
        dataTaskDidBecomeDownloadTask?(session, dataTask, downloadTask)
        print("urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {")
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        
        dataTaskDidBecomeStreamTask?(session, dataTask, streamTask)
        print("urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {")
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        dataTaskDidReceiveData?(session, dataTask, data)
        print("urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {")
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void)  {
        
        dataTaskWillCacheResponseWithCompletion?(session, dataTask, proposedResponse, completionHandler)
        print("urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void)  {")
    }
}

//extension SessionDelegate: URLSessionDownloadDelegate {
//    
//}
//
//extension SessionDelegate: URLSessionStreamDelegate {
//    
//}
