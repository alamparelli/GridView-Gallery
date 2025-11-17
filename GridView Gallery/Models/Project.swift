//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import Foundation
import SwiftData

@Model
class Project {
    var name: String?
        
    init(name: String? = nil) {
        self.name = name
    }
}
