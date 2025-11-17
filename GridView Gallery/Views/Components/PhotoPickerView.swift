//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @State private var pickerItems: [PhotosPickerItem] = []
    @Binding var selectedImages: [ImageItem]
    
    var body: some View {
        PhotosPicker(selection: $pickerItems, maxSelectionCount: 5, matching: .images , preferredItemEncoding: .compatible ) {
            Label("Add a photo", systemImage: "photo.on.rectangle")
                .labelStyle(.iconOnly)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .onChange(of: pickerItems) {
            Task {
                for item in pickerItems {
                    if let data = try await item.loadTransferable(type: Data.self) {
                        // Convert data to UIImage first
                        if let uiImage = UIImage(data: data) {
                            if let imageDisk = uiImage.jpegData(compressionQuality: 0.5) {
                                let image = ImageItem(imageData: imageDisk)
                                selectedImages.append(image)
                            }
                        }
                    }
                }
                pickerItems = []
            }
        }
    }
}
//
//#Preview {
//    PhotoPickerView()
//}
