//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import Foundation
import SwiftData

@Model
class Project: Comparable {
    var name: String?
    @Relationship(deleteRule: .nullify, inverse: \ImageItem.project) var images: [ImageItem]?

    var unwrappedName: String {
        name ?? "Unknown"
    }
    
    init(name: String? = nil) {
        self.name = name
    }

    public static func < (lhs: Project, rhs: Project) -> Bool {
        return lhs.unwrappedName < rhs.unwrappedName
    }
}
