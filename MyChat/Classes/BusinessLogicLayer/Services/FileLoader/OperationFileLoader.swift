//
//  OperationFileLoader.swift
//  MyChat
//
//  Created by Administrator on 17.03.2021.
//

import Foundation

// MARK: - OperationFileLoader

class OperationFileLoader: FileLoaderProtocol {
    
    // MARK: - Public properties

    static var shared: FileLoaderProtocol = OperationFileLoader()

    var state: StateLoader = .ready
    
    // MARK: - Private properties

    private let queue = OperationQueue()
    
    // MARK: - Initialization

    init() { queue.maxConcurrentOperationCount = 1 }

    // MARK: - Public methods
    
    func writeFile<T: Codable>(object: T, completion: @escaping (Result<Bool, Error>) -> Void) {

        let fileWriteOperation = FileWriteOperation(object: object, loader: self)

        fileWriteOperation.completionBlock = {
            OperationQueue.main.addOperation {
                if let result = fileWriteOperation.result {
                    completion(result)
                } else {
                    completion(.failure(FileWorkManagerError.writeError))
                }
            }
        }

        state = .executing
        queue.addOperations([fileWriteOperation], waitUntilFinished: false)
    }

    func readFile<T: Codable>(completion: @escaping (Result<T, Error>) -> Void) {

        let fileReadOperation = FileReadOperation<T>()

        fileReadOperation.completionBlock = {
            OperationQueue.main.addOperation {
                if let result = fileReadOperation.result {
                    completion(result)
                } else {
                    completion(.failure(FileWorkManagerError.writeError))
                }
            }
        }

        state = .executing
        queue.addOperations([fileReadOperation], waitUntilFinished: false)
    }

    func cancelAllOperations() {

        state = .cancelled
        queue.cancelAllOperations()
    }
}

// MARK: AsyncOperation

class AsyncOperation: Operation {
    
    // MARK: - Enums

    enum State: String {
        case ready, executing, finished, cancelled

        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    // MARK: - Public properties

    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

// MARK: - AsyncOperation public properties

extension AsyncOperation {

    override var isReady: Bool {
        return super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    override var isCancelled: Bool {
        return state == .cancelled
    }

    override var isAsynchronous: Bool {
        return true
    }

    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }

    override func cancel() {
        state = .cancelled
    }
}

// MARK: FileWriteOperationProtocol

protocol FileWriteOperationProtocol {
    var result: Result<Bool, Error>? { get }
}

// MARK: - FileWriteOperation

class FileWriteOperation<T: Codable>: AsyncOperation, FileWriteOperationProtocol {

    // MARK: - Private properties
    
    private let object: T
    private var loader: FileLoaderProtocol
    private(set) var result: Result<Bool, Error>?

    // MARK: - Initialization
    
    init(object: T, loader: FileLoaderProtocol) {
        self.object = object
        self.loader = loader
        super.init()
    }
    
    // MARK: - Public methods

    override func main() {

        // TODO: sleep
        // sleep(20)

        if isCancelled {
            state = .finished
            return
        }

        FileWorkManager<T>().write(object: object, loader: loader) { result in
            self.result = result
            self.state = .finished
        }
    }
}

// MARK: FileReadOperationProtocol

protocol FileReadOperationProtocol {
    associatedtype Types
    var result: Result<Types, Error>? { get }
}

// MARK: - FileWriteOperation

class FileReadOperation<T: Codable>: AsyncOperation, FileReadOperationProtocol {

    // MARK: - Private properties
    
    private(set) var result: Result<T, Error>?

    // MARK: - Public methods
    
    override func main() {

        // TODO: sleep
        // sleep(3)

        if isCancelled {
            state = .finished
            return
        }

        FileWorkManager<T>().read { result in
            self.result = result
            self.state = .finished
        }
    }
}