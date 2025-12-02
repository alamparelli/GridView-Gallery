//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

@Observable
class DatabaseService {
    let context: ModelContext
    
    var images: [ImageItem] = []
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
        
    func refreshAll() {
        refreshImages()
    }
    
    private func refreshImages() {
        images = queryExtract(ImageItem.self)
        refreshProjects()
    }
    
    private func refreshProjects() {
        projects = queryExtract(Project.self)
        
        for project in projects {
            updateLayout(for: project)
        }
    }
    
    private func queryExtract<T: PersistentModel>(_ type : T.Type) -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: #Predicate { _ in true})
        return (try? context.fetch(descriptor)) ?? [T]()
    }
    
    private func save() {
        try? context.save()
    }
    
    func getTags() -> [Tag] {
        let descriptor = FetchDescriptor<Tag>(predicate: #Predicate { _ in true})
        return (try? context.fetch(descriptor)) ?? [Tag]()
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
    
    private func cleanTags() {
        let descriptor = FetchDescriptor<Tag>(predicate: #Predicate { _ in true})
        guard let emptyTags = try? context.fetch(descriptor) else { return }
        
        for tag in emptyTags {
            context.delete(tag)
        }
        
        save()
    }
    
    func checkTag(_ name: String) -> Tag {
        cleanTags()
        
        let descriptor = FetchDescriptor<Tag>(predicate: #Predicate { $0.name == name})

        if let existingTags = try? context.fetch(descriptor).first {
            return existingTags
        } else {
            return Tag(name: name)
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
