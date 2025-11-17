//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

struct ImageView: View {
    var image: ImageItem
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    
    @State private var openDetails: Bool = false
    
    var body: some View {
        if let thumbnailData = image.thumbnailData, let uiImage = UIImage(data: thumbnailData), let thumbnail = uiImage.preparingThumbnail(of: CGSize(width: uiImage.size.width / 2, height: uiImage.size.height / 2)) {
            Button {
//                ns.navigate(to: Destination.imageDetails(image))
//                ns.navigate(to: Destination.debug(image, db.images))
                openDetails = true
            } label: {Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .clipShape(.rect(cornerRadius: 10))
            }
            .sheet(isPresented: $openDetails) {
                DebugView(image: image, images: db.images)
            }
        }
    }
}
