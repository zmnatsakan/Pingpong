//
//  DictionaryExtension.swift
//  PingPong
//
//  Created by Mnatsakan Work on 30.10.23.
//

import Foundation

extension Dictionary: RawRepresentable where Key == Int, Value == Bool {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),  // convert from String to Data
            let result = try? JSONDecoder().decode([Int:Bool].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),   // data is  Data type
              let result = String(data: data, encoding: .utf8) // coerce NSData to String
        else {
            return "{}"  // empty Dictionary resprenseted as String
        }
        return result
    }
}
