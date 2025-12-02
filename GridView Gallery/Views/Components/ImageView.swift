//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

/// Individual image tile with selection support and tap-to-view.
struct ImageView: View {
    /// The image to display.
    let image: ImageItem
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db

    /// Whether this image is selected in edit mode.
    @State private var isSelected = false

    /// Shows ImageDetailView sheet.
    @State private var openDetails = false

    /// Tap animation state.
    @State private var isTapped = false
        
    var body: some View {
        if let uiImage = UIImage(data: image.thumbnailData) {
            ZStack (alignment: .topTrailing) {
                Button{
                    actionButton(image)
                } label: {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .clipShape(.rect(cornerRadius: 10))
                        .scaleEffect(isTapped ? 0.99 : 1.0 )
                }

                if db.isEditingImages {
                    SelectionView(isSelected: isSelected)
                        .padding()
                }
            }
            .onChange(of: db.isEditingImages) {
                if !db.isEditingImages{
                    isSelected = false
                }
            }
            .onChange(of: db.resetSelectedItems) {
                if db.resetSelectedItems {
                    isSelected = false
                }
            }
            .sheet(isPresented: $openDetails) {
                ImageDetailView(image: image, images: db.images)
            }
        }
    }

    /// Handles tap: toggles selection in edit mode, opens detail view otherwise.
    /// - Parameter image: The tapped image.
    func actionButton(_ image: ImageItem) {
        withAnimation(.smooth(duration: 0.1)) {
            isTapped = true
            if db.isEditingImages {
                if isSelected {
                    isSelected = false
                    db.selectedImagesWhenEditingList.remove(image)
                } else {
                    isSelected = true
                    db.selectedImagesWhenEditingList.insert(image)
                    db.resetSelectedItems = false
                }
            } else {
                openDetails = true
            }
        } completion: {
            isTapped = false
        }
    }
}
