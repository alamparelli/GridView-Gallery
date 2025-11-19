//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

struct SelectionView: View {
    let isSelected: Bool
    
    var body: some View {
        Circle()
            .fill(isSelected ? Color.accent : Color.white.opacity(0.3))
            .stroke(.white, lineWidth: 2 )
            .frame(width: 20, height: 20)
    }
}

struct ImageView: View {
    let image: ImageItem
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    
    @State private var isSelected = false
    @State private var showSelection = false
    
    @State private var openDetails = false
    
    var body: some View {
        if let uiImage = UIImage(data: image.thumbnailData) {
            ZStack (alignment: .topTrailing) {
                Button {
                    actionButton(image)
                } label: {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .clipShape(.rect(cornerRadius: 10))
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
        if db.isEditing {
            withAnimation{
                if isSelected {
                    isSelected = false
                    db.selectedImagesWhenEditingList.remove(image)
                } else {
                    isSelected = true
                    db.selectedImagesWhenEditingList.insert(image)
                    db.resetSelectedItems = false
                }
                showSelection = true
            }
        } else {
            openDetails = true
        }
    }
}
