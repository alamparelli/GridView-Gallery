//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

/// Full-screen image viewer with zoom, pan, and swipe gestures.
struct ImageDetailView: View {
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    @Environment(\.dismiss) var dismiss

    /// Currently displayed image.
    var image: ImageItem?

    /// All images for horizontal scrolling.
    var images: [ImageItem]

    @State private var selectedImageID: PersistentIdentifier?
    @State private var selectedImage: ImageItem?

    /// Shows edit metadata sheet.
    @State private var showEditDetails = false

    @State private var project: Project?
    @State private var description = ""

    /// Whether UI chrome is hidden.
    @State private var fullScreen = true

    /// Zoom gesture tracking.
    @State private var lastScale = 1.0
    @State private var scale = 1.0

    /// Pan gesture tracking.
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero

    /// Minimum zoom level.
    private let minScale = 1.0

    /// Maximum zoom level.
    private let maxScale = 3.0

    @Namespace private var animation

    /// Combined gesture handling pinch, pan, double-tap, and single-tap.
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { state in
                let delta = state / lastScale
                scale *= delta
                lastScale = state
            }
            .onEnded { state in
                withAnimation {
                    validateScaleLimit()
                }
                lastScale = 1.0
            }
            .simultaneously(
                with: DragGesture(minimumDistance: scale > 1.0 ? 0 : 30)
                    .onChanged({ value in
                        if scale > 1.0 {
                            withAnimation(.interactiveSpring()) {
                                offset = handleOffsetChange(value.translation)
                            }
                        }
                    })
                    .onEnded({ _ in
                        if scale > 1.0 {
                            lastOffset = offset
                        }
                    })
            )
            .simultaneously(
                with: scale > 1.0 || offset != .zero ? TapGesture(count: 2)
                    .onEnded {
                        withAnimation {
                            lastScale = 1.0
                            scale = 1.0
                            offset = .zero
                            lastOffset = .zero
                        }
                    } : nil
            )
            .simultaneously(
                with: scale == 1.0 ? TapGesture()
                    .onEnded { _ in
                        withAnimation {
                            fullScreen.toggle()
                        }
                    } : nil
            )
    }

    /// Combines current drag with previous offset.
    /// - Parameter offset: Current drag translation.
    /// - Returns: Combined offset.
    private func handleOffsetChange(_ offset: CGSize) -> CGSize {
        var newOffset: CGSize = .zero
        newOffset.width = offset.width + lastOffset.width
        newOffset.height = offset.height + lastOffset.height
        return newOffset
    }

    /// Ensures scale doesn't go below minimum.
    /// - Returns: Clamped scale value.
    func getMinimumZoomScale() -> CGFloat {
        return max(scale, minScale)
    }

    /// Ensures scale doesn't exceed maximum.
    /// - Returns: Clamped scale value.
    func getMaximumZoomScale() -> CGFloat {
        return min(scale, maxScale)
    }

    /// Clamps scale between min and max limits.
    func validateScaleLimit() {
        scale = getMinimumZoomScale()
        scale = getMaximumZoomScale()
    }
 
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    TabView(selection: $selectedImageID) {
                        ForEach(images.sorted(by: { $0.createdAt > $1.createdAt }) ) { img in
                            ScrollView {
                                VStack(spacing: 0) {
                                    LazyPhotoView(
                                        image: img,
                                        isCurrentPhoto: selectedImageID == img.id,
                                        fullScreen: fullScreen,
                                    )
                                    .aspectRatio(contentMode: fullScreen ? .fit : .fill)
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: fullScreen ? .infinity : 250
                                    )
                                    .frame(height: fullScreen ? proxy.size.height : nil)
                                    .clipped()
                                    .scaleEffect(scale)
                                    .offset(fullScreen ? offset : .zero)
                                    .gesture(!showEditDetails ? magnification : nil)
                                    .matchedGeometryEffect(id: "image-\(img.id)", in: animation)
                                    
                                    if !fullScreen {
                                        if showEditDetails {
                                            AddDetailsImageView(imageItem: $selectedImage, project: $project, description: $description)
                                                .padding()
                                        } else {
                                            DetailReadOnlyView(image: $selectedImage)
                                        }
                                    }
                                }
                            }
                            .scrollIndicators(.never)
                            .tag(img.persistentModelID)
                            .gesture(!showEditDetails ? magnification : nil)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: showEditDetails ? .never : .automatic))
                    .highPriorityGesture(
                        showEditDetails ? DragGesture() : nil
                    )
                    .animation(.easeInOut, value: showEditDetails)
                    
                    if !fullScreen {
                        VStack {
                            HStack {
                                Button {
                                    showEditDetails ? showEditDetails = false : dismiss()
                                } label: {
                                    Label("Close", systemImage:  "xmark")
                                        .labelStyle(.iconOnly)
                                        .foregroundStyle(.accent)
                                        .padding(12)
                                        .glassEffect()
                                        .clipShape(Circle())
                                }
                                
                                Spacer()
                                
                                if showEditDetails {
                                    Text("Edit")
                                        .font(.subheadline.bold())
                                }
                                
                                Spacer()
                                
                                Button {
                                    editAction()
                                } label: {
                                    Label(showEditDetails ? "Done" : "Edit" , systemImage: showEditDetails ? "square.and.arrow.down" : "pencil")
                                        .labelStyle(.iconOnly)
                                        .foregroundStyle(.accent)
                                        .padding(12)
                                        .background(.accentColorInverted)
                                        .clipShape(Circle())
                                }
                            }
                            .padding()
                            
                            Spacer()
                        }
                    }
                }
            }
            .onChange(of: image) {
                selectedImageID = image?.id
            }
            .onChange(of: selectedImageID) { oldValue, newValue in
                if let newID = newValue,
                   let newImage = images.first(where: { $0.persistentModelID == newID }) {
                    selectedImage = newImage

                    // if edit , update fields
                    if showEditDetails {
                        description = newImage.fulldescription ?? ""
                        project = newImage.project
                    }
                }

                // Reset zoom when changing photos
                lastScale = 1.0
                scale = 1.0
                offset = .zero
                lastOffset = .zero
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
                
                // Set the initial selected image
                if let image = image {
                    selectedImageID = image.persistentModelID
                    selectedImage = image
                }
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
        }
    }
    
    func editAction() {
            if showEditDetails {
                showEditDetails = false
                
                // Only save description and project
                selectedImage!.fulldescription = description
                selectedImage!.project = project
                
                db.editImageItem()
            } else {
                // Load state from model
                description = selectedImage?.fulldescription ?? ""
                project = selectedImage?.project
                
                showEditDetails = true
            }

    }
}
