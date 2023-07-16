//
//  File.swift
//  
//
//  Created by Joe Maghzal on 10/03/2023.
//

import Foundation

///NetworkUI: The form data parameters of a request
public struct FormData {
//MARK: - Properties
    internal var key: String
    internal var stringValue: String?
    internal var dataValue: Data?
    internal var fileName: String?
//MARK: - Functions
///NetworkUI: Creates a form data parameter from a key, some data and an optional filename
    public static func parameter(key: String, data: Data, fileName: String? = nil) -> Self {
        return FormData(key: key, dataValue: data, fileName: fileName)
    }
///NetworkUI: Creates a form data parameter from a key, data and a `String` value
    public static func parameter(key: String, value: String) -> Self {
        return FormData(key: key, stringValue: value)
    }
}
