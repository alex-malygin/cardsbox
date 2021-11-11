//
//  KeychainManager.swift
//  CardsBox
//
//  Created by Alexander Malygin on 11/10/21.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touch
    case face
   
    var localized: String? {
        switch self {
        case .none: return nil
        case .touch: return "Do you want to use TouchID for your next login?"
        case .face: return  "Do you want to use FaceID for your next login?"
        }
    }
}

class KeychainManager {
    private let keychain = Keychain()
    private let bundle = Bundle.main.bundleIdentifier ?? "some.string.instead.bundle"

    var biometricType: BiometricType {
        let authContext = LAContext()
        _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .none
        }
    }

    func saveCredentials(email: String?, pass: String?) {
        try? keychain.deleteCredentials(server: bundle)
        try? keychain.addCredentials(Keychain.Credentials(username: email ?? "", password: pass ?? ""), server: bundle)
    }

    func getCredentials(message: String) -> (email: String?, pass: String?) {
        do {
            let creds = try keychain.readCredentials(message: message, server: bundle)
            return (creds.username, creds.password)
        } catch _ {
            return (nil, nil)
        }
    }
}

/// Apple implemenattion
private class Keychain {
    struct Credentials {
        var username: String
        var password: String
    }

    /// Keychain errors we might encounter.
    struct KeychainError: Error {
        var status: OSStatus

        var localizedDescription: String {
            return SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error."
        }
    }

    /// Stores credentials for the given server.
    func addCredentials(_ credentials: Credentials, server: String) throws {
        // Use the username as the account, and get the password as data.
        let account = credentials.username
        let password = credentials.password.data(using: String.Encoding.utf8)!

        // Create an access control instance that dictates how the item can be read later.
        let access = SecAccessControlCreateWithFlags(nil, // Use the default allocator.
                                                     kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                     .userPresence,
                                                     nil) // Ignore any error.

        // Allow a device unlock in the last 10 seconds to be used to get at keychain items.
        let context = LAContext()
        context.touchIDAuthenticationAllowableReuseDuration = 10

        // Build the query for use in the add operation.
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: server,
                                    kSecAttrAccessControl as String: access as Any,
                                    kSecUseAuthenticationContext as String: context,
                                    kSecValueData as String: password]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }

    /// Reads the stored credentials for the given server.
    func readCredentials(message: String, server: String) throws -> Credentials {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecUseOperationPrompt as String: message,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { throw KeychainError(status: status) }

        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
            else {
                throw KeychainError(status: errSecInternalError)
        }

        return Credentials(username: account, password: password)
    }

    /// Deletes credentials for the given server.
    func deleteCredentials(server: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }
}

