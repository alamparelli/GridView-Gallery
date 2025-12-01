//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ImageItemView: View {
    var index: Int = 0
    var images: [ImageItem]
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        if let image = images[index].thumbnailImage {
            Image(uiImage: image )
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
        }
    }
}

struct ProjectSquareView: View {
    var project: Project
    var images: [ImageItem]
    @Environment(DatabaseService.self) var db
    @Environment(NavigationService.self) var ns
    @State private var isTapped = false
    
    @State private var isSelected = false
    
    var id: Int {
        if images.count < 3 {
            return 1
        } else {
            return Range(2...3).randomElement()!
        }
    }
    
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
                        switch id {
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
