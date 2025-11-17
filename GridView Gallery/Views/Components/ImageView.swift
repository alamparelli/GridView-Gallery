//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

struct ImageView: View {
    var image: Data
    
    var body: some View {
        if let uiImage = UIImage(data: image), let thumbnail = uiImage.preparingThumbnail(of: CGSize(width: uiImage.size.width / 2, height: uiImage.size.height / 2)) {
            Image(uiImage: thumbnail)
                .resizable()
                .scaledToFit()
                .clipped()
                .clipShape(.rect(cornerRadius: 10))
        }
    }
}
