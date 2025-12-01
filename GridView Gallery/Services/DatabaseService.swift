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
    
    // Editbutton
    var selectedImagesWhenEditingList = Set<ImageItem>()
    var selectedProjectsWhenEditingList: Set<Project> = []

    var isEditingImages = false
    var isEditingProjects = false
    
    var resetSelectedItems = false
    var resetSelectedProjects = false
    var projectToUpdate: Project?
    
    init(context: ModelContext) {
        self.context = context
        refreshAll()
    }
    
    func updateLayout(for project: Project) {
        if project.imageCount < 3 {
            project.layout = 1
        } else {
            project.layout = Range(2...3).randomElement()!
        }
    }
    
    func updateProjectImage() {
        if let pr = self.projectToUpdate {
            for image in selectedImagesWhenEditingList {
                image.project = pr
            }
        }

        refreshImages()
        resetSelectedItems = true
    }
    
    func resetSelectedImagesWhenEditingList() {
        selectedImagesWhenEditingList.removeAll()
    }
    
    func resetSelectedProjectsWhenEditingList() {
        selectedProjectsWhenEditingList.removeAll()
    }
    
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
    
    func refreshAll() {
        refreshImages()
        refreshTags()
    }
    
    private func cleanTags() {
        for tag in tags {
            if tag.imagesCount == 0 {
                context.delete(tag)
            }
        }
        save()
    }
    
    private func refreshImages() {
        images = queryExtract(ImageItem.self)
        refreshProjects()
        cleanTags()
    }
    
    private func refreshProjects() {
        projects = queryExtract(Project.self)
        
        for project in projects {
            updateLayout(for: project)
        }
        
        cleanTags()
    }
    
    private func refreshTags() {
        tags = queryExtract(Tag.self)
        cleanTags()
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
        save()
        refreshImages()
    }
    
    func editImageItem() {
        save()
        refreshImages()
    }
    
    func removeImageItem(_ imageItem: ImageItem) {
        context.delete(imageItem)
        save()
        refreshImages()
    }
    
    // helped by Claude to create a generic
    func removeImageItems<C: Collection>(_ images: C) where C.Element == ImageItem {
        for image in images {
            _ = image.imageData // fix for external storage
            
            context.delete(image)
        }

        save()
        refreshImages()
        resetSelectedImagesWhenEditingList()
    }
    
    func addTag(_ tag: Tag) {
        context.insert(tag)
        save()
        refreshTags()
    }
    
    func checkTag(_ name: String) -> Tag {
        if tags.filter({$0.name == name}).isEmpty {
            let tag = Tag(name: name)
            addTag(tag)
            return tag
        } else {
            let tag = tags.filter({$0.name == name}).first!
            return tag
        }
    }
    
    func addProject(_ project: Project) {
        context.insert(project)
        
        projectToUpdate = project // needed for moving functionality
        
        save()
        refreshProjects()
    }
    
    func editProject() {
        save()
        refreshProjects()
    }
    
    func removeProject(_ project: Project) {
        context.delete(project)
        save()
        refreshProjects()
    }
    
    func removeProjects<C: Collection>(_ projects: C, _ removeImages: Bool = false) where C.Element == Project {
        for project in projects {
            if removeImages {
                if let images = project.images {
                    for image in images {
                        context.delete(image)
                    }
                }
            }
            context.delete(project)
        }
    
        save()
        refreshAll()
        resetSelectedProjectsWhenEditingList()
    }
}
