//
//  OKHTTPClient.swift
//
//
//  Created by Kevin Hermawan on 08/06/24.
//

import Combine
import Foundation

internal struct OKHTTPClient {
    private let decoder: JSONDecoder = .default
    static let shared = OKHTTPClient()
}

internal extension OKHTTPClient {
    func send(request: URLRequest) async throws -> Void {
        let (_, response) = try await URLSession.shared.data(for: request)
        
        try validate(response: response)
    }
    
    func send<T: Decodable>(request: URLRequest, with responseType: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        
        return try decoder.decode(T.self, from: data)
    }
    
    /// NOTE: T must be Sendable because values are sent across concurrency domains for streaming.
    func stream<T: Decodable & Sendable>(request: URLRequest, with responseType: T.Type) -> AsyncThrowingStream<T, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    let (bytes, response) = try await URLSession.shared.bytes(for: request)
                    try validate(response: response)

                    continuation.onTermination = { terminationState in
                        // Cancellation of our task should cancel the URLSessionDataTask
                        if case .cancelled = terminationState {
                            bytes.task.cancel()
                        }
                    }

                    var buffer = Data()
                    
                    for try await byte in bytes {
                        buffer.append(byte)
                        
                        while let chunk = self.extractNextJSON(from: &buffer) {
                            do {
                                let decodedObject = try self.decoder.decode(T.self, from: chunk)
                                continuation.yield(decodedObject)
                            } catch {
                                continuation.finish(throwing: error)
                                return
                            }
                        }
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

internal extension OKHTTPClient {
    func send<T: Decodable>(request: URLRequest, with responseType: T.Type) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                try self.validate(response: response)
                
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func send(request: URLRequest) -> AnyPublisher<Void, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try self.validate(response: response)
                
                return ()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// NOTE: T must be Sendable because values are sent across concurrency domains for streaming.
    func stream<T: Decodable & Sendable>(request: URLRequest, with responseType: T.Type) -> AnyPublisher<T, Error> {
        let delegate = StreamingDelegate()
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: .main)
        
        let task = session.dataTask(with: request)
        task.resume()
        
        var buffer = Data()
        
        return delegate.publisher()
            .tryMap { newData -> [T] in
                buffer.append(newData)
                var decodedObjects: [T] = []
                
                while let chunk = self.extractNextJSON(from: &buffer) {
                    let decodedObject = try self.decoder.decode(T.self, from: chunk)
                    decodedObjects.append(decodedObject)
                }
                
                return decodedObjects
            }
            .flatMap { decodedObjects -> AnyPublisher<T, Error> in
                Publishers.Sequence(sequence: decodedObjects)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveCancel: {
                task.cancel()
            })
            .eraseToAnyPublisher()
    }
}

private extension OKHTTPClient {
    func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
    func extractNextJSON(from buffer: inout Data) -> Data? {
        var isEscaped = false
        var isWithinString = false
        var nestingDepth = 0
        var objectStartIndex = buffer.startIndex
        
        for (index, byte) in buffer.enumerated() {
            let character = Character(UnicodeScalar(byte))
            
            if isEscaped {
                isEscaped = false
            } else if character == "\\" {
                isEscaped = true
            } else if character == "\"" {
                isWithinString.toggle()
            } else if !isWithinString {
                switch character {
                case "{":
                    nestingDepth += 1
                    if nestingDepth == 1 {
                        objectStartIndex = index
                    }
                case "}":
                    nestingDepth -= 1
                    if nestingDepth == 0 {
                        let range = objectStartIndex..<buffer.index(after: index)
                        let jsonObject = buffer.subdata(in: range)
                        buffer.removeSubrange(range)
                        
                        return jsonObject
                    }
                default:
                    break
                }
            }
        }
        
        return nil
    }
}
