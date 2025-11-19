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
    
    // Edit mode
    @State private var project: Project?
    @State private var tags: [Tag] = []
    @State private var description = ""
    
    
    // Gestures
    @State private var fullScreen: Bool = false
    @State private var lastScale = 1.0
    @State private var scale = 1.0
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    
    private let minScale = 1.0
    private let maxScale = 3.0
    
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
                with: TapGesture(count: 2)
                    .onEnded {
                        withAnimation {
                            lastScale = 1.0
                            scale = 1.0
                            offset = .zero
                            lastOffset = .zero
                        }
                }
            )
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
    
    var fullScreenGesture: some Gesture {
        TapGesture()
            .onEnded { _ in
                withAnimation {
                    fullScreen.toggle()
                }
            }
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
                                            .gesture(fullScreenGesture)
                                    }
                                    
                                    if !fullScreen {
                                        if showEditDetails {
                                            AddDetailsImageView(project: $project, tags: $tags, description: $description)
                                                .padding()
                                        } else {
                                            DetailReadOnlyView(img: img)
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
                            .gesture(fullScreenGesture)
                            .gesture(magnification)
                            .tag(img.persistentModelID)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: showEditDetails ? .never : .automatic))
                .ignoresSafeArea(edges: .top)
                //            .disabled(showEditDetails)
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
                                Image(systemName: "xmark")
                                    .foregroundStyle(.accent)
                                    .padding(12)
                                    .glassEffect()
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Button {
                                doWork()
                            } label: {
                                Image(systemName: showEditDetails ? "square.and.arrow.down" : "pencil")
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
            //            .toolbar {
            //                ToolbarItem(placement: .cancellationAction) {
            //                    Button{
            //                        dismiss()
            //                    } label: {
            //                        Image(systemName: "xmark")
            //                            .foregroundStyle(.accent)
            //                    }
            //                }
            //                ToolbarItem(placement: .confirmationAction) {
            //                    Button{
            //                        showEditDetails = true
            //                    } label: {
            //                        Image(systemName: "pencil")
            //                            .foregroundStyle(.accent)
            //                    }
            //                    .tint(.accentColorInverted)
            //                    .buttonStyle(.borderedProminent)
            //                }
            //            }
        }
    }
    
    func doWork() {
        if showEditDetails {
            showEditDetails = false
            
            selectedImage!.fulldescription = description
            selectedImage!.project = project
            selectedImage!.tags = tags
            
            db.editImageItem()
        } else {
            description = selectedImage?.fulldescription ?? "ddd"
            tags = selectedImage?.tags ?? []
            project = selectedImage?.project
            
            showEditDetails = true
        }
    }
}
//#Preview {
//    DebugView()
//}
