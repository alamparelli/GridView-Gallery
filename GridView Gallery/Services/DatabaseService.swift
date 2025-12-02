//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

/// Service managing database operations for images, projects, and tags.
@Observable
class DatabaseService {
    /// The SwiftData model context.
    let context: ModelContext

    /// All images in the database.
    var images: [ImageItem] = []

    /// All projects in the database.
    var projects: [Project] = []

    /// Images selected in edit mode.
    var selectedImagesWhenEditingList = Set<ImageItem>()

    /// Projects selected in edit mode.
    var selectedProjectsWhenEditingList: Set<Project> = []

    /// Whether image list is in edit mode.
    var isEditingImages = false

    /// Whether project list is in edit mode.
    var isEditingProjects = false

    /// Flag to trigger resetting selected images.
    var resetSelectedItems = false

    /// Flag to trigger resetting selected projects.
    var resetSelectedProjects = false

    /// Project to move images to.
    var projectToUpdate: Project?

    /// Creates a database service and loads all data.
    /// - Parameter context: The SwiftData model context.
    init(context: ModelContext) {
        self.context = context
        refreshAll()
    }

    /// Assigns a random layout variant to a project based on image count.
    /// - Parameter project: The project to update.
    func updateLayout(for project: Project) {
        if project.imageCount < 3 {
            project.layout = 1
        } else {
            project.layout = Range(2...3).randomElement()!
        }
    }

    /// Moves selected images to the specified project.
    func updateProjectImage() {
        if let pr = self.projectToUpdate {
            for image in selectedImagesWhenEditingList {
                image.project = pr
            }
        }

        refreshImages()
        resetSelectedItems = true
    }

    /// Clears the image selection.
    func resetSelectedImagesWhenEditingList() {
        selectedImagesWhenEditingList.removeAll()
    }

    /// Clears the project selection.
    func resetSelectedProjectsWhenEditingList() {
        selectedProjectsWhenEditingList.removeAll()
    }

    /// Refreshes all cached data from the database.
    func refreshAll() {
        refreshImages()
    }

    /// Refreshes images and triggers project refresh.
    private func refreshImages() {
        images = queryExtract(ImageItem.self)
        refreshProjects()
    }

    /// Refreshes projects and updates their layouts.
    private func refreshProjects() {
        projects = queryExtract(Project.self)

        for project in projects {
            updateLayout(for: project)
        }
    }

    /// Fetches all instances of a model type.
    /// - Parameter type: The model type to fetch.
    /// - Returns: Array of model instances.
    private func queryExtract<T: PersistentModel>(_ type : T.Type) -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: #Predicate { _ in true})
        return (try? context.fetch(descriptor)) ?? [T]()
    }

    /// Persists changes to the database.
    private func save() {
        try? context.save()
    }

    /// Fetches all tags from the database.
    /// - Returns: Array of all tags.
    func getTags() -> [Tag] {
        let descriptor = FetchDescriptor<Tag>(predicate: #Predicate { _ in true})
        return (try? context.fetch(descriptor)) ?? [Tag]()
    }

    /// Adds a new image to the database.
    /// - Parameter imageItem: The image to add.
    func addImageItem(_ imageItem: ImageItem) {
        context.insert(imageItem)
        save()
        refreshImages()
    }

    /// Saves changes to an existing image.
    func editImageItem() {
        save()
        refreshImages()
    }

    /// Removes an image from the database.
    /// - Parameter imageItem: The image to remove.
    func removeImageItem(_ imageItem: ImageItem) {
        context.delete(imageItem)
        save()
        refreshImages()
    }

    /// Removes multiple images from the database.
    /// - Parameter images: Collection of images to remove.
    func removeImageItems<C: Collection>(_ images: C) where C.Element == ImageItem {
        for image in images {
            _ = image.imageData // Access data to ensure external storage deletion

            context.delete(image)
        }

        save()
        refreshImages()
        resetSelectedImagesWhenEditingList()
    }

    /// Removes tags that have no associated images.
    private func cleanTags() {
        let descriptor = FetchDescriptor<Tag>(predicate: #Predicate { _ in true})
        guard let emptyTags = try? context.fetch(descriptor) else { return }

        for tag in emptyTags {
            context.delete(tag)
        }

        save()
    }

    /// Returns an existing tag or creates a new one.
    /// - Parameter name: The tag name.
    /// - Returns: Existing or new tag instance.
    func checkTag(_ name: String) -> Tag {
//        cleanTags()

        let descriptor = FetchDescriptor<Tag>(predicate: #Predicate { $0.name == name})

        if let existingTags = try? context.fetch(descriptor).first {
            return existingTags
        } else {
            return Tag(name: name)
        }
    }

    /// Adds a new project to the database.
    /// - Parameter project: The project to add.
    func addProject(_ project: Project) {
        context.insert(project)

        projectToUpdate = project

        save()
        refreshProjects()
    }

    /// Saves changes to an existing project.
    func editProject() {
        save()
        refreshProjects()
    }

    /// Removes a project from the database.
    /// - Parameter project: The project to remove.
    func removeProject(_ project: Project) {
        context.delete(project)
        save()
        refreshProjects()
    }

    /// Removes multiple projects from the database.
    /// - Parameters:
    ///   - projects: Collection of projects to remove.
    ///   - removeImages: Whether to also delete associated images.
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
