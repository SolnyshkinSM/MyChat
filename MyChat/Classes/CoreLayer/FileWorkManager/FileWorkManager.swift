//
//  FileWorkManager.swift
//  MyChat
//
//  Created by Administrator on 13.03.2021.
//

import Foundation

// MARK: - FileWorkManagerError

public enum FileWorkManagerError: Error {
    case firstRead
    case writeError
    case readError
}

// MARK: - FileWorkManager

class FileWorkManager<T: Codable> {

    // MARK: - Private properties

    static private var plistURL: URL? {
        guard let documents = FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documents.appendingPathComponent(String(describing: T.self) + ".plist")
    }

    // MARK: - Public methods

    func read(completion: @escaping (Result<T, Error>) -> Void) {

        // TODO: sleep
        // sleep(3)

        let decoder = PropertyListDecoder()

        guard let plistURL = FileWorkManager.plistURL
        else { return completion(.failure(FileWorkManagerError.readError)) }

        if !FileManager.default.fileExists(atPath: plistURL.path) {
            return completion(.failure(FileWorkManagerError.firstRead))
        }

        guard let data = try? Data(contentsOf: plistURL),
              let object = try? decoder.decode(T.self, from: data)
        else { return completion(.failure(FileWorkManagerError.readError)) }

        // TODO: test failure
        /*if Int.random(in: 0...1) != 0 {
            return completion(.failure(FileWorkManagerError.readError))
        }*/

        return completion(.success(object))
    }

    func write(object: T, loader: FileLoaderProtocol, completion: @escaping (Result<Bool, Error>) -> Void) {

        // TODO: sleep
        // sleep(3)

        let encoder = PropertyListEncoder()

        guard let data = try? encoder.encode(object),
              let plistURL = FileWorkManager.plistURL
        else { return completion(.failure(FileWorkManagerError.writeError)) }

        // TODO: test failure
        /*if Int.random(in: 0...1) != 0 {
            return completion(.failure(FileWorkManagerError.writeError))
        }*/

        if loader.state == .cancelled {
            return completion(.success(false))
        }

        if FileManager.default.fileExists(atPath: plistURL.path) {
            do {
                try data.write(to: plistURL)
            } catch {
                return completion(.failure(FileWorkManagerError.writeError))
            }
        } else {
            FileManager.default.createFile(atPath: plistURL.path, contents: data, attributes: nil)
        }

        return completion(.success(true))
    }
}
