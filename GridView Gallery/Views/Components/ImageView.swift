//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

struct ImageView: View {
    var image: ImageItem
    @Environment(NavigationService.self) var ns
    
    var body: some View {
        if let thumbnailData = image.thumbnailData, let uiImage = UIImage(data: thumbnailData), let thumbnail = uiImage.preparingThumbnail(of: CGSize(width: uiImage.size.width / 2, height: uiImage.size.height / 2)) {
            Button {
                ns.navigate(to: Destination.imageDetails(image))
            } label: {Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
}
