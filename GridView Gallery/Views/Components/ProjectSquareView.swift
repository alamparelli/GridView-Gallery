//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

/// Helper view displaying a single image from a project's image array.
struct ImageItemView: View {
    /// Index in the images array.
    var index: Int = 0

    /// Project's images.
    var images: [ImageItem]

    /// Width of the image view.
    var width: CGFloat

    /// Height of the image view.
    var height: CGFloat
    
    var body: some View {
        if index < images.count, let image = images[index].thumbnailImage {
            Image(uiImage: image )
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
        }
    }
}

/// Project preview tile with variable layout based on image count.
struct ProjectSquareView: View {
    /// The project to display.
    var project: Project

    /// Project's images.
    var images: [ImageItem]
    @Environment(DatabaseService.self) var db
    @Environment(NavigationService.self) var ns

    /// Tap animation state.
    @State private var isTapped = false

    /// Whether selected in edit mode.
    @State private var isSelected = false
        
    var body: some View {
        Button {
            actionButton(project)
        } label: {
            ZStack (alignment: .topTrailing) {
                VStack (alignment: .leading, spacing: 4) {
                    if images.isEmpty {
                        HStack (spacing: 0) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                        }
                        .frame(width: 180, height: 173)
                        .cornerRadius(10)
                    } else {
                        switch project.layout {
                        case 1:
                            HStack (spacing: 0) {
                                ImageItemView(index: 0, images: images, width: 180, height: 173)
                            }
                            .frame(width: 180, height: 173)
                            .cornerRadius(10)
                        case 2:
                            HStack (spacing: 0) {
                                ImageItemView(index: 0, images: images, width: 90, height: 173)

                                VStack (spacing: 0) {
                                    ImageItemView(index: 1, images: images, width: 90, height: 86.5)

                                    ImageItemView(index: 2, images: images, width: 90, height: 86.5)

                                }
                            }
                            .frame(width: 180, height: 173)
                            .cornerRadius(10)
                        default:
                            HStack (spacing: 0) {
                                VStack (spacing: 0) {
                                    ImageItemView(index: 0, images: images, width: 90, height: 86.5)

                                    ImageItemView(index: 1, images: images, width: 90, height: 86.5)

                                }
                                ImageItemView(index: 2, images: images, width: 90, height: 173)

                            }
                            .frame(width: 180, height: 173)
                            .cornerRadius(10)
                        }
                    }
                    VStack (alignment: .leading) {
                        Text(project.unwrappedName)
                            .fontWeight(.semibold)
                        Text("^[\(images.count) Item](inflect:true)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .scaleEffect(isTapped ? 0.99 : 1.0 )
                
                if db.isEditingProjects {
                    SelectionView(isSelected: isSelected)
                        .padding()
                }
            }
        }

        .onChange(of: db.isEditingProjects) {
            if !db.isEditingProjects{
                isSelected = false
            }
        }
        .onChange(of: db.resetSelectedItems) {
            if db.resetSelectedItems {
                isSelected = false
            }
        }
    }

    /// Handles tap: toggles selection in edit mode, navigates to project otherwise.
    /// - Parameter project: The tapped project.
    func actionButton(_ project: Project) {
        withAnimation(.smooth(duration: 0.1)) {
            isTapped = true
            if db.isEditingProjects {
                    if isSelected {
                        isSelected = false
                        db.selectedProjectsWhenEditingList.remove(project)
                    } else {
                        isSelected = true
                        db.selectedProjectsWhenEditingList.insert(project)
                        db.resetSelectedItems = false
                    }
            } else {
                ns.navigate(to: Destination.project(project))
            }
        } completion: {
            isTapped = false
        }
    }
}

#Preview {
    ProjectSquareView(project: Project(), images: [])
}
