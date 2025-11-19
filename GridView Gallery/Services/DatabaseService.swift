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
    
    func projectImages(_ project: Project) -> [ImageItem] {
        let pName = project.name
        let descriptor = FetchDescriptor<ImageItem>(predicate: #Predicate { $0.project?.name == pName})
        var data: [ImageItem] = []
        
        do {
            data = try context.fetch(descriptor)
        } catch {
            print("Error fetching notes: \(error)")
        }
        return data
    }
    
    init(context: ModelContext) {
        self.context = context
        
        self.refreshAll()
    }
    
    private func refreshAll() {
        self.images = self.queryExtract(ImageItem.self)
        self.projects = self.queryExtract(Project.self)
        self.tags = self.queryExtract(Tag.self)
    }
    
    private func refreshImages() {
        self.images = self.queryExtract(ImageItem.self)
    }
    
    private func refreshProjects() {
        self.projects = self.queryExtract(Project.self)
    }
    
    private func refreshTags() {
        self.tags = self.queryExtract(Tag.self)
    }
    
    private func queryExtract<T: PersistentModel>(_ type : T.Type) -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: #Predicate { _ in true})
        var data: [T] = []
        
        do {
            data = try context.fetch(descriptor)
        } catch {
            print("Error fetching notes: \(error)")
        }
        
        return data
    }
    
    private func save() {
        try? context.save()
    }
    
    func addImageItem(_ imageItem: ImageItem) {
        context.insert(imageItem)
        self.save()
        self.refreshImages()
    }
    
    func editImageItem() {
        self.save()
        self.refreshImages()
    }
    
    func removeImageItem(_ imageItem: ImageItem) {
        context.delete(imageItem)
        self.save()
        self.refreshImages()
    }
    
    func removeImageItems(_ images: [ImageItem]) {
        for image in images {
            _ = image.imageData // fix for external storage
            context.delete(image)
        }
        self.save()
        self.refreshImages()
    }
    
    func addTag(_ tag: Tag) {
        context.insert(tag)
        self.save()
        self.refreshTags()
    }
    
    func editTag() {
        
    }
    
    func removeTag(_ tag: Tag) {
        context.delete(tag)
        self.save()
        self.refreshTags()
    }
    
    func addProject(_ project: Project) {
        context.insert(project)
        self.save()
        self.refreshProjects()
    }
    
    func editProject() {
        self.save()
        self.refreshProjects()
    }
    
    func removeProject(_ project: Project) {
        context.delete(project)
        self.save()
        self.refreshProjects()
    }
}
