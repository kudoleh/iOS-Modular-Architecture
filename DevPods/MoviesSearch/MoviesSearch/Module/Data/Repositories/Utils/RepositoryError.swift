//
//  RepositoryError.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 25/04/2020.
//

import Foundation
import Networking

enum RepositoryError: Error {
    case dataTransfer(DataTransferError)
    case persistentStorageError
}
