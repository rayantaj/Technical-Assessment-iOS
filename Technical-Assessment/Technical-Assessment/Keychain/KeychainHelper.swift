//
//  KeychainHelper.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 15/12/2024.
//

import Foundation

class KeychainHelper {

    static let shared = KeychainHelper()

    private init() {}

    func save(_ value: String, forKey key: String) -> Bool {
        let data = Data(value.utf8)

        // Check if the item already exists
        if let _ = try? read(forKey: key) {
            // Update existing item
            let query = keychainQuery(forKey: key)
            let attributesToUpdate: [String: Any] = [kSecValueData as String: data]

            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == errSecSuccess
        } else {
            // Add new item
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]

            let status = SecItemAdd(query as CFDictionary, nil)
            return status == errSecSuccess
        }
    }

    func read(forKey key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                return nil
            } else {
                throw KeychainError.unhandledError(status: status)
            }
        }

        guard let data = result as? Data else {
            throw KeychainError.dataConversionError
        }

        return String(data: data, encoding: .utf8)
    }

    func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }

    private func keychainQuery(forKey key: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
    }

    enum KeychainError: Error {
        case unhandledError(status: OSStatus)
        case dataConversionError
    }
}
