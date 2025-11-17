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
        if let uiImage = UIImage(data: image.thumbnailData) {
            Button {
//                ns.navigate(to: Destination.imageDetails(image))
//                ns.navigate(to: Destination.debug(image, db.images))
                openDetails = true
            } label: {Image(uiImage: uiImage)
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
