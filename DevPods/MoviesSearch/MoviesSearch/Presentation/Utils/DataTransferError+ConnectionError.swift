//
//  DataTransferError+ConnectionError.swift
//  App
//
//  Created by Oleh Kudinov on 29.10.19.
//

import Foundation
import Networking

extension DataTransferError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
