//
//  DataTaskDelegate.swift
//  Pidgey
//
//  Created by Carlos Duclos on 5/29/18.
//

import Foundation

open class TaskDelegate: NSObject {

    // MARK: Properties

    /// The serial operation queue used to execute all operations after the task completes.
    open let queue: OperationQueue

    /// The data returned by the server.
    public var data: Data? { return nil }

    /// The error generated throughout the lifecyle of the task.
    public var error: Error?

    var task: URLSessionTask?

    // MARK: Lifecycle

    init(task: URLSessionTask? = nil) {
        self.queue = {
            let operationQueue = OperationQueue()
            operationQueue.maxConcurrentOperationCount = 1
            operationQueue.isSuspended = true
            operationQueue.qualityOfService = .utility
            return operationQueue
        }()
    }
}

protocol Taskable {

    var dataTask: URLSessionDataTask { get }
    var progress: Progress { get set }
    var progressHandler: (closure: Request.ProgressHandler, queue: DispatchQueue)? { get set }
}

class DataTaskDelegate: TaskDelegate, Taskable, URLSessionDataDelegate {
    
    var dataTask: URLSessionDataTask { return task as! URLSessionDataTask }
    
    var progress: Progress
    
    var progressHandler: (closure: Request.ProgressHandler, queue: DispatchQueue)?
    
    var didReceivedResponse: ((URLSession, URLSessionDataTask, URLResponse) -> Void)?
    
    var didReceivedData: ((URLSession, URLSessionDataTask, Data) -> Void)?
    
    var willCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse) -> Void)?
    
    var didBecomeDownloadTask: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?
//    var didBecomeStreamTask: ((URLSession, URLSessionDataTask, URLSessionStreamTask) -> Void)?
    
    override init(task: URLSessionTask? = nil) {
        progress = Progress(totalUnitCount: 0)
        super.init(task: task)
    }
    
    /// Tells the delegate that the data task received the initial reply (headers) from the server.
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        didReceivedResponse?(session, dataTask, response)
        completionHandler(.allow)
    }
    
    /// Tells the delegate that the data task has received some of the expected data.
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        didReceivedData?(session, dataTask, data)
    }
    
    /// Asks the delegate whether the data (or upload) task should store the response in the cache.
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        willCacheResponse?(session, dataTask, proposedResponse)
        completionHandler(nil)
    }
    
    /// Tells the delegate that the data task was changed to a download task.
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        didBecomeDownloadTask?(session, dataTask, downloadTask)
    }
    
    /// Tells the delegate that the data task was changed to a stream task.
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
//
//    }
    
}
