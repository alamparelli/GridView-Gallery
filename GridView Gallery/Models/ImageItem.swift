//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import Foundation
import SwiftData

@Model
class ImageItem {
    @Attribute(.externalStorage) var imageData: Data
    var fulldescription: String?
    var projects: [Project]?
    var tags: [Tag]?
    var createdAt: Date = Date()
    
    init(imageData: Data, fulldescription: String? = nil, projects: [Project]? = nil, tags: [Tag]? = nil, createdAt: Date) {
        self.imageData = imageData
        self.fulldescription = fulldescription
        self.projects = projects
        self.tags = tags
        self.createdAt = createdAt
    }
}
