//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

/// Displays thumbnail immediately, then loads full resolution asynchronously.
struct LazyPhotoView: View {
    /// The image to display.
    let image: ImageItem

    /// Whether this is the currently visible image.
    let isCurrentPhoto: Bool

    /// Whether in fullscreen mode.
    let fullScreen: Bool

    /// Loaded full-resolution image.
    @State private var fullImage: UIImage?

    /// Whether full image is currently loading.
    @State private var isLoadingFull = false
    
    var body: some View {
        ZStack {
            // Always show thumbnail as base layer
            if let thumbnail = image.thumbnailImage {
                Image(uiImage: thumbnail)
                    .resizable()
            } else {
                placeholderView
            }
            
            // Overlay full resolution when loaded
            if let fullImg = fullImage {
                Image(uiImage: fullImg)
                    .resizable()
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

    /// Loads the full-resolution image asynchronously.
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
            .overlayModifierRounded()
    }
}

