//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

struct ImageView: View {
    let image: ImageItem
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    
    @State private var isSelected = false    
    @State private var openDetails = false
    @State private var isTapped = false
    
    var body: some View {
        if let uiImage = UIImage(data: image.thumbnailData) {
            ZStack (alignment: .topTrailing) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .clipShape(.rect(cornerRadius: 10))
                    .scaleEffect(isTapped ? 0.99 : 1.0 )
                    .onTapGesture {
                        actionButton(image)
                    }

                if db.isEditing {
                    SelectionView(isSelected: isSelected)
                        .padding()
                }
            }
            .onChange(of: db.isEditing) {
                if !db.isEditing{
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
    
    func actionButton(_ image: ImageItem) {
        withAnimation(.smooth(duration: 0.1)) {
            isTapped = true
            if db.isEditing {
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
