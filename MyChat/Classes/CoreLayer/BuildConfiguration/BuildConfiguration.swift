//
//  BuildConfiguration.swift
//  MyChat
//
//  Created by Administrator on 08.05.2021.
//

import Foundation

// MARK: - BuildConfiguration

enum BuildConfiguration {

    enum Error: Swift.Error { case missingKey, invalidValue }

    static func getValue<Type>(for key: String) throws -> Type where Type: LosslessStringConvertible {

        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else { throw Error.missingKey }

        switch object {
        case let string as String:
            guard let value = Type(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

// MARK: - API

enum API {

    static var keyLoadImages: String {
        do {
            return try BuildConfiguration.getValue(for: "API_KEY_LOAD_IMAGES")
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    static var urlLoadImages: String {
        do {
            return try BuildConfiguration.getValue(for: "API_URL_LOAD_IMAGES")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
