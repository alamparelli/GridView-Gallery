//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ImageItem {
    @Attribute(.externalStorage) var imageData: Data
    var fulldescription: String?
    var project: Project
    var tags: [Tag]?
    var createdAt: Date
    
    init(imageData: Data, fulldescription: String? = nil, project: Project = Project(), tags: [Tag]? = nil, createdAt: Date = Date()) {
        self.imageData = imageData
        self.fulldescription = fulldescription
        self.project = project
        self.tags = tags
        self.createdAt = createdAt
    }
    
    var uiImage: UIImage? {
        UIImage(data: imageData)
    }
}
