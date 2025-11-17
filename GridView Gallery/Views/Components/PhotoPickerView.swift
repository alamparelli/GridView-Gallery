//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @State private var pickerItems: [PhotosPickerItem] = []
    @Environment(DatabaseService.self) var db
    
    var body: some View {
        PhotosPicker(selection: $pickerItems, maxSelectionCount: 6, matching: .images , preferredItemEncoding: .compatible ) {
            Label("Add a photo", systemImage: "photo.badge.plus")
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
}

#Preview {
    PhotoPickerView()
}
