//
//  File.swift
//  
//
//  Created by Joe Maghzal on 10/03/2023.
//

import Foundation

public struct FormData {
//MARK: - Properties
    internal var key: String
    internal var stringValue: String?
    internal var dataValue: Data?
    internal var fileName: String?
//MARK: - Functions
    public static func parameter(key: String, data: Data, fileName: String? = nil) -> Self {
        return FormData(key: key, dataValue: data, fileName: fileName)
    }
    public static func parameter(key: String, value: String) -> Self {
        return FormData(key: key, stringValue: value)
    }
}
