//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

@Observable
class DatabaseService {
    let context: ModelContext
    
    var images: [ImageItem] = []
    var tags: [Tag] = []
    var projects: [Project] = []
    
    init(context: ModelContext) {
        self.context = context
    }
    
    private func save() {
        try? context.save()
    }
    
    func addImageItem(_ imageItem: ImageItem) {
        context.insert(imageItem)
        self.save()
    }
    
    func editImageItem() {
        
    }
    
    func removeImageItem(_ imageItem: ImageItem) {
        context.delete(imageItem)
        self.save()
    }
    
    func removeImageItems(_ images: [ImageItem]) {
        for image in images {
            context.delete(image)
        }
        self.save()
    }
    
    func addTag(_ tag: Tag) {
        context.insert(tag)
        self.save()
    }
    
    func editTag() {
        
    }
    
    func removeTag(_ tag: Tag) {
        context.delete(tag)
        self.save()
    }
    
    func addProject(_ project: Project) {
        context.insert(project)
        self.save()
    }
    
    func editProject() {
        
    }
    
    func removeProject(_ project: Project) {
        context.delete(project)
        self.save()
    }
}
