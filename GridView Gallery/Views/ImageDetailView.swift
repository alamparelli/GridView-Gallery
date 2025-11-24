//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

struct ImageDetailView: View {
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    @Environment(\.dismiss) var dismiss
    
    var image: ImageItem?
    var images: [ImageItem]

    @State private var selectedImageID: PersistentIdentifier?
    @State private var selectedImage: ImageItem?
    @State private var showEditDetails = false
    
    @State private var project: Project?
    @State private var description = ""
    
    // Gestures
    @State private var fullScreen: Bool = false
    @State private var lastScale = 1.0
    @State private var scale = 1.0
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    
    private let minScale = 1.0
    private let maxScale = 3.0
    
    @Namespace private var animation
    
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
                with: scale > 1.0 ? TapGesture(count: 2)
                    .onEnded {
                        withAnimation {
                            lastScale = 1.0
                            scale = 1.0
                            offset = .zero
                            lastOffset = .zero
                        }
                    } : nil
            )
    }
    
    var fullScreenGesture: some Gesture {
        TapGesture()
            .onEnded { _ in
                withAnimation {
                    fullScreen.toggle()
                }
            }
    }
    
    private func handleOffsetChange(_ offset: CGSize) -> CGSize {
        var newOffset: CGSize = .zero
        newOffset.width = offset.width + lastOffset.width
        newOffset.height = offset.height + lastOffset.height
        return newOffset
    }
    
    func getMinimumZoomScale() -> CGFloat {
        return max(scale, minScale)
    }
    
    func getMaximumZoomScale() -> CGFloat {
        return min(scale, maxScale)
    }
    
    func validateScaleLimit() {
        scale = getMinimumZoomScale()
        scale = getMaximumZoomScale()
    }
 
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedImageID) {
                    ForEach(images.sorted(by: { $0.createdAt > $1.createdAt }) ) { img in
                        if !fullScreen {
                            ScrollView {
                                VStack(spacing: 0) {
                                    if let uiImage = UIImage(data: img.thumbnailData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: 600, maxHeight: 250)
                                            .clipped()
                                            .contentShape(Rectangle())
                                            .gesture(!showEditDetails ? fullScreenGesture: nil)
                                            .matchedGeometryEffect(id: "image-\(img.id)", in: animation)
                                    }
                                    
                                    if !fullScreen {
                                        if showEditDetails {
                                            AddDetailsImageView(imageItem: img, tags: .constant([]), project: $project, description: $description)
                                                .padding()
                                        } else {
                                            DetailReadOnlyView(image: img)
                                        }
                                    }
                                }
                            }
                            .scrollIndicators(.never)
                            .tag(img.persistentModelID)
                        } else {
                            LazyPhotoView(
                                image: img,
                                isCurrentPhoto: selectedImageID == img.id
                            )
                            .scaleEffect(scale)
                            .offset(offset)
                            .gesture(!showEditDetails ? fullScreenGesture: nil)
                            .gesture(!showEditDetails ? magnification : nil)
                            .tag(img.persistentModelID)
                            .matchedGeometryEffect(id: "image-\(img.id)", in: animation)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: showEditDetails ? .never : .automatic))
                .ignoresSafeArea(edges: .top)
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
                            }
                            
                            Spacer()
                            
                            Button {
                                doWork()
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
            .onChange(of: image) {
                selectedImage = image
                selectedImageID = image?.id
            }
            .onChange(of: selectedImageID) { oldValue, newValue in
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
    
    func doWork() {
        if showEditDetails {
            showEditDetails = false
            
            // Only save description and project
            // Tags are already modified directly by TagsView!
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
//#Preview {
//    DebugView()
//}
