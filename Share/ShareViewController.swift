//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import UIKit
import Social
import SwiftUI
import SwiftData
internal import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        
        if let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProviders = extensionItem.attachments {
                let hostingView = UIHostingController(rootView: ShareView(itemProviders: itemProviders, extensionContext: extensionContext))
                hostingView.view.frame = view.frame
                view.addSubview(hostingView.view)
        }
    }
}

fileprivate struct ShareView: View {
    var db: DatabaseService
    let modelContainer: ModelContainer
    
    var itemProviders: [NSItemProvider]
    var extensionContext: NSExtensionContext?
    
    init(itemProviders: [NSItemProvider], extensionContext: NSExtensionContext?) {
        self.itemProviders = itemProviders
        self.extensionContext = extensionContext
        
        let schema = Schema([ImageItem.self])
        
        do {
            modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Cannot setup SwiftData")
        }
        
        db = DatabaseService(context: modelContainer.mainContext)
    }
    
    @State private var items = [Item]()
    @State var project: Project?
    
    var body: some View {
        NavigationStack {
            GeometryReader {
                let size = $0.size

                VStack(spacing: 15) {
                    Text("Add")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .overlayModifierRounded()
                        .padding(.bottom, 10)
                    
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 15) {
                            ForEach(items) { item in
                                Image(uiImage: item.previewImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: size.width - 10)
                            }
                        }
                        .padding(.horizontal, 15)
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .frame(height: 300)
                    .scrollIndicators(.hidden)
                    
                    if !db.projects.isEmpty {
                        PickerProjectView(project: $project, text: "None")
                    }
                    
                    Button("Save", systemImage: "checkmark", action: saveImages)
                        .buttonStyle(.borderedProminent)
                    
                    Spacer(minLength: 0)
                }
                .padding(15)
                .onAppear {
                    extractItems(size: size)
                }
            }
        }
    }

    func extractItems(size: CGSize) {
        guard items.isEmpty else { return }
        
        for provider in itemProviders {
            
            // Check if it's a URL (like from Safari)
            if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { item, _ in
                    if let url = item as? URL {
                        // Download the image from the URL
                        self.downloadImage(from: url, size: size)
                    }
                }
            }
            // Check if it's direct image data (like from Photos app)
            else if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                let _ = provider.loadDataRepresentation(for: .image) { data, _ in
                    if let data, let image = UIImage(data: data) {
                        self.addImageToItems(imageData: data, image: image, size: size)
                    }
                }
            }
        } 
    }

    func downloadImage(from url: URL, size: CGSize) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                return
            }
            
            if let data, let image = UIImage(data: data) {
                self.addImageToItems(imageData: data, image: image, size: size)
            }
        }.resume()
    }

    func addImageToItems(imageData: Data, image: UIImage, size: CGSize) {
        if let thumbnail = image.preparingThumbnail(of: .init(width: size.width, height: 300)) {
            DispatchQueue.main.async {
                items.append(.init(imageData: imageData, previewImage: thumbnail))
            }
        }
    }

    func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }

    func saveImages() {
        do {
            for item in items {
                modelContainer.mainContext.insert(ImageItem(imageData: item.imageData, project: project))
            }
            try modelContainer.mainContext.save()
            dismiss()
        } catch {
            print(error.localizedDescription)
            dismiss()
        }

    }

    private struct Item: Identifiable {
        let id = UUID()
        let imageData: Data
        var previewImage: UIImage
    }
}
