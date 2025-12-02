//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import Foundation
import SwiftData

/// A tag for categorizing and organizing images.
@Model
class Tag {
    /// The tag's display name.
    var name: String

    /// Images associated with this tag.
    @Relationship(deleteRule: .nullify, inverse: \ImageItem.tags) var imageItems: [ImageItem]?

    /// The number of images using this tag.
    var imagesCount: Int {
        imageItems?.count ?? 0
    }

    /// Creates a new tag.
    /// - Parameter name: The tag name.
    init(name: String) {
        self.name = name
    }
}
