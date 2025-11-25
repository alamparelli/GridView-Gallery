//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct LazyPhotoView: View {
    let image: ImageItem
    let isCurrentPhoto: Bool
    let fullScreen: Bool
    
    @State private var fullImage: UIImage?
    @State private var isLoadingFull = false
    
    var body: some View {
        ZStack {
            // Always show thumbnail as base layer
            if let thumbnail = image.thumbnailImage {
                Image(uiImage: thumbnail)
                    .resizable()
//                    .aspectRatio(contentMode: fullScreen ? .fit : .fill)
//                    .scaledToFit()
            } else {
                placeholderView
            }
            
            // Overlay full resolution when loaded
            if let fullImg = fullImage {
                Image(uiImage: fullImg)
                    .resizable()
//                    .aspectRatio(contentMode: fullScreen ? .fit : .fill)
//                    .scaledToFit()
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
            }
        }
        .onChange(of: isCurrentPhoto) { oldValue, newValue in
            if newValue && fullImage == nil && !isLoadingFull {
                loadFullResolution()
            }
        }
        .onAppear {
            if isCurrentPhoto && fullImage == nil {
                loadFullResolution()
            }
        }
    }
    
    private func loadFullResolution() {
        isLoadingFull = true
        
        // Load asynchronously to avoid blocking UI
        Task.detached(priority: .userInitiated) {
            guard let uiImage = await UIImage(data: image.imageData) else {
                await MainActor.run {
                    isLoadingFull = false
                }
                return
            }
            
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.2)) {
                    fullImage = uiImage
                }
                isLoadingFull = false
            }
        }
    }
    
    private var placeholderView: some View {
        Color.gray.opacity(0.3)
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
    }
}
//
//#Preview {
//    LazyPhotoView()
//}
