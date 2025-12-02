//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import Foundation
import SwiftData

/// A project that organizes and groups related images together.
@Model
class Project: Comparable {
    /// The project's display name.
    var name: String?

    /// Images belonging to this project.
    @Relationship(deleteRule: .nullify, inverse: \ImageItem.project) var images: [ImageItem]?

    /// Layout variant identifier for displaying project previews.
    var layout: Int = 1

    /// The number of images in this project.
    var imageCount: Int {
        images?.count ?? 0
    }

    /// Returns the project name or "Unknown" if nil.
    var unwrappedName: String {
        name ?? "Unknown"
    }

    /// Returns the project's images or empty array if nil.
    var unwrappedImages: [ImageItem] {
        images ?? []
    }

    /// Creates a new project.
    /// - Parameter name: Optional project name.
    init(name: String? = nil) {
        self.name = name
    }

    /// Sorts projects by image presence first, then alphabetically by name.
    public static func < (lhs: Project, rhs: Project) -> Bool {
        let lhsHasImages = !(lhs.images?.isEmpty ?? true)
        let rhsHasImages = !(rhs.images?.isEmpty ?? true)
        
        // If one has images and the other doesn't, the one with images comes first
        if lhsHasImages != rhsHasImages {
            return lhsHasImages && !rhsHasImages
        }
        
        // Both have same image status, sort by name
        return lhs.unwrappedName < rhs.unwrappedName
    }
}
