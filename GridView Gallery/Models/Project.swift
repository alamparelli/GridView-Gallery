//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import Foundation
import SwiftData

@Model
class Project: Comparable {
    var name: String?
    @Relationship(deleteRule: .nullify, inverse: \ImageItem.project) var images: [ImageItem]?
    
    var layout: Int = 1
    var imageCount: Int {
        images?.count ?? 0
    }

    var unwrappedName: String {
        name ?? "Unknown"
    }
    
    var unwrappedImages: [ImageItem] {
        images ?? []
    }
    
    init(name: String? = nil) {
        self.name = name
    }

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
