//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import Foundation
import SwiftData

@Model
class Tag {
    var name: String
    @Relationship(deleteRule: .nullify, inverse: \ImageItem.tags) var imageItems: [ImageItem]?
    
    init(name: String) {
        self.name = name
    }
}
