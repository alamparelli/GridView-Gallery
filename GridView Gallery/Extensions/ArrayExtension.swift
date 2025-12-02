//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import Foundation

/// Makes codable arrays compatible with AppStorage by conforming to RawRepresentable.
extension Array: @retroactive RawRepresentable where Element: Codable {
    /// Decodes an array from a JSON string.
    /// - Parameter rawValue: JSON string representation.
    public init?(rawValue: String) {
        guard
            let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }

    /// Encodes the array to a JSON string.
    public var rawValue: String {
        guard
            let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else { return "" }
        return result
    }
}
