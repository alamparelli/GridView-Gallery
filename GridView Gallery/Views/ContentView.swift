//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import PhotosUI


struct ContentView: View {
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    
    @State private var pickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack {
            StaggeredList(images: db.images)
        }
        .toolbar {
            ToolbarItem {
                PhotosPicker(selection: $pickerItems, maxSelectionCount: 5, matching: .images , preferredItemEncoding: .compatible ) {
                    Label("Add photos", systemImage: "photo.badge.plus")
                }
                .onChange(of: pickerItems) {
                    Task {
                        for item in pickerItems {
                            if let data = try await item.loadTransferable(type: Data.self) {
                                // Convert data to UIImage first
                                if let uiImage = UIImage(data: data) {
                                    if let imageDisk = uiImage.jpegData(compressionQuality: 0.5) {
                                        let image = ImageItem(imageData: imageDisk)
                                        db.addImageItem(image)
                                    }
                                }
                            }
                        }
                        pickerItems = []
                    }
                }
            }
            ToolbarItem {
                Button("Delete") {
                    db.removeImageItems(db.images)
                }
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    ContentView()
}
