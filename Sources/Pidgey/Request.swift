//
//  Request.swift
//  Pidgey
//
//  Created by Carlos Duclos on 6/3/18.
//

import Foundation

open class Request {
    
    // MARK: Helper Types
    
    /// A closure executed when monitoring upload or download progress of a request.
    public typealias ProgressHandler = (Progress) -> Void
    
    enum RequestTask {
        case data(URLSessionTask?)
//        case download(URLSessionTask?)
//        case upload(URLSessionTask?)
//        case stream(URLSessionTask?)
    }
    
    // MARK: Properties
    
    /// The delegate for the underlying task.
    open internal(set) var delegate: TaskDelegate {
        get {
            return taskDelegate
        }
        set {
            taskDelegate = newValue
        }
    }
    
    /// The underlying task.
    open var task: URLSessionTask? { return delegate.task }
    
    /// The session belonging to the underlying task.
    open let session: URLSession
    
    /// The request sent or to be sent to the server.
    open var request: URLRequest? { return task?.originalRequest }
    
    /// The response received from the server, if any.
    open var response: HTTPURLResponse? { return task?.response as? HTTPURLResponse }
    
    /// The number of times the request has been retried.
    open internal(set) var retryCount: UInt = 0
    
//    let originalTask: TaskConvertible?
    
    var startTime: CFAbsoluteTime?
    var endTime: CFAbsoluteTime?
    
    var validations: [() -> Void] = []
    
    private var taskDelegate: TaskDelegate
    
    // MARK: Lifecycle
    
    init(session: URLSession, requestTask: RequestTask, error: Error? = nil) {
        self.session = session
        
        switch requestTask {
        case .data(let task):
            taskDelegate = DataTaskDelegate(task: task)
            
//        case .download(_): break
//            taskDelegate = DownloadTaskDelegate(task: task)
//
//        case .upload(_): break
//            taskDelegate = UploadTaskDelegate(task: task)
//
//        case .stream(_): break
//            taskDelegate = TaskDelegate(task: task)
        }
        
        delegate.error = error
        delegate.queue.addOperation { self.endTime = CFAbsoluteTimeGetCurrent() }
    }
    
    // MARK: State
    
    /// Resumes the request.
    open func resume() {
        guard let task = task else { delegate.queue.isSuspended = false ; return }
        
        if startTime == nil { startTime = CFAbsoluteTimeGetCurrent() }
        
        task.resume()
    }
    
    /// Suspends the request.
    open func suspend() {
        guard let task = task else { return }
        task.suspend()
    }
    
    /// Cancels the request.
    open func cancel() {
        guard let task = task else { return }
        task.cancel()
    }
}

open class DataRequest: Request {
    
    // MARK: Helper Types
    
//    func task(session: URLSession, queue: DispatchQueue) throws -> URLSessionTask {
//        do {
//            let urlRequest = try self.urlRequest.adapt(using: adapter)
//            return queue.sync { session.dataTask(with: urlRequest) }
//
//        } catch {
//
//            throw AdaptError(error: error)
//        }
//    }
}
