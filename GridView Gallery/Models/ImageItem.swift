//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import Foundation
import SwiftData
import SwiftUI

/// An image item with associated metadata, tags, and project membership.
@Model
class ImageItem {
    /// Full-resolution image data stored externally.
    @Attribute(.externalStorage) var imageData: Data

    /// Optimized thumbnail data stored externally.
    @Attribute(.externalStorage) var thumbnailData: Data

    /// Optional description text for the image.
    var fulldescription: String?

    /// The project this image belongs to, if any.
    @Relationship(deleteRule: .nullify) var project: Project?

    /// Tags associated with this image for categorization.
    @Relationship(deleteRule: .nullify) var tags: [Tag]

    /// Date when the image was added to the gallery.
    var createdAt: Date

    /// Cached thumbnail image to avoid repeated decoding.
    @Transient private var cachedThumbnailImage: UIImage?

    /// Cached full-resolution image to avoid repeated decoding.
    @Transient private var cachedFullImage: UIImage?

    /// Creates a new image item with automatic thumbnail generation.
    /// - Parameters:
    ///   - imageData: Full-resolution image data.
    ///   - fulldescription: Optional description text.
    ///   - project: Optional parent project.
    ///   - tags: Array of tags for categorization.
    ///   - createdAt: Creation date, defaults to now.
    init(imageData: Data, fulldescription: String? = nil, project: Project? = nil, tags: [Tag] = [], createdAt: Date = Date()) {
        self.imageData = imageData
        self.fulldescription = fulldescription
        self.project = project
        self.tags = tags
        self.createdAt = createdAt
        
        self.thumbnailData = Self.generateThumbnail(from: imageData) ?? Data()
    }

    /// Returns the full-resolution UIImage.
    var uiImage: UIImage? {
        UIImage(data: imageData)
    }

    /// Returns the cached thumbnail UIImage, decoding only once.
    var thumbnailImage: UIImage? {
        if cachedThumbnailImage == nil {
            cachedThumbnailImage = UIImage(data: thumbnailData)
        }
        return cachedThumbnailImage
    }

    /// Generates an optimized thumbnail from image data.
    /// - Parameters:
    ///   - data: Source image data.
    ///   - maxSize: Maximum dimension in points.
    /// - Returns: JPEG-compressed thumbnail data or nil if generation fails.
    private static func generateThumbnail(from data: Data, maxSize: CGFloat = 800) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        
        let scale = min(maxSize / image.size.width, maxSize / image.size.height, 1.0)
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        
        guard let thumbnail = image.preparingThumbnail(of: newSize) else { return nil }
        return thumbnail.jpegData(compressionQuality: 0.8)
    }
}
