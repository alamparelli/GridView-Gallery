//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @AppStorage("eu.lamparelli.grid-gallery.recentSearches")
        var recentSearches: [String] = []
    @Environment(DatabaseService.self) var db

    @State private var searchText: String = ""
    var topTags: [Tag] {
        return db.tags
            .sorted(by: { $0.imagesCount > $1.imagesCount })
            .prefix(5)
            .map { $0 }
    }
    
    var images: [ImageItem] {
        if searchText.isEmpty {
            return db.images
        } else {
            return db.images.filter {
                $0.tags.contains(where: { $0.name.localizedStandardContains(searchText) }) || $0.fulldescription?.localizedStandardContains(searchText) == true
            }
        }
    }
    
    var projects: [Project] {
        if searchText.isEmpty {
            return db.projects
        } else {
            return db.projects.filter {
                $0.unwrappedName.localizedStandardContains(searchText)
            }
        }
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
        
    var body: some View {
        ScrollView {
            if searchText.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Group {
                        Text("Recent Searches")
                            .fontWeight(.semibold)
                        
                        ForEach(recentSearches, id:\.self) { recent in
                            Button {
                                searchText = recent
                            } label: {
                                Text("\(recent)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Text("Top Tags")
                            .fontWeight(.semibold)
                        
                        ForEach(topTags) { tag in
                            Button {
                                searchText = tag.name
                            } label: {
                                Text("#\(tag.name)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Group {
                        if !projects.isEmpty {
                            Text("Projects")
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                        }
                        
                        LazyVGrid(columns: columns) {
                            ForEach(projects) { project in
                                if let images = project.images {
                                    ProjectSquareView(project: project, images: images)
                                }
                            }
                        }
                        .padding()
                        
                        if !images.isEmpty {
                            Text("Images")
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                        }
                        StaggeredList(images: images)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .searchable(text: $searchText, isPresented: .constant(true), prompt: "Search by tag, description, or project name")
        .animation(.default, value: searchText)
        .onSubmit(of: .search) {
            withAnimation {
                recentSearches.insert(searchText, at: 0)
                if recentSearches.count > 5 {
                    recentSearches.remove(at: recentSearches.count - 1)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
