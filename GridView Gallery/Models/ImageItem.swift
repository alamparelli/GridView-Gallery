//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ImageItem {
    @Attribute(.externalStorage) var imageData: Data
    @Attribute(.externalStorage) var thumbnailData: Data
    var fulldescription: String?
    @Relationship(deleteRule: .nullify) var project: Project?
    var tags: [Tag]?
    var createdAt: Date
    
    init(imageData: Data, fulldescription: String? = nil, tags: [Tag]? = nil, createdAt: Date = Date()) {
        self.imageData = imageData
        self.fulldescription = fulldescription
        self.tags = tags
        self.createdAt = createdAt
        
        self.thumbnailData = Self.generateThumbnail(from: imageData)!
    }
    
    var uiImage: UIImage? {
        UIImage(data: imageData)
    }
    
    // Generate thumbnail once and cache it
    private static func generateThumbnail(from data: Data, maxSize: CGFloat = 800) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        
        let scale = min(maxSize / image.size.width, maxSize / image.size.height, 1.0)
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        
        guard let thumbnail = image.preparingThumbnail(of: newSize) else { return nil }
        return thumbnail.jpegData(compressionQuality: 0.8)
    }
}
