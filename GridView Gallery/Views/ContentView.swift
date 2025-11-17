//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    
    @State private var showPicker = false
    
    var body: some View {
        VStack {
            if db.images.isEmpty {
                ContentUnavailableView {
                    PhotoPickerView()
                } description: {
                    Text("Nothing to Show yet")
                }
            } else {
                StaggeredList(images: db.images)
            }
        }
        .toolbar {
            ToolbarItem {
                PhotoPickerView()
            }
            ToolbarItem {
                Button("Delete") {
                    db.removeImageItems(db.images)
                }
            }
            ToolbarItem {
                EditButton()
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    ContentView()
}
