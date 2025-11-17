//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ImageItemView: View {
    var index: Int = 0
    var images: [ImageItem]
    
    var body: some View {
        if let image = images[index].uiImage?.preparingThumbnail(of: images[index].uiImage!.size) {
            Image(uiImage: image )
                .resizable()
                .scaledToFill()
                .clipped()
            
        }
    }
}

struct ProjectSquareView: View {
    var project: Project
    var images: [ImageItem]
    
    var id: Int {
        if images.count < 3 {
            return 1
        } else {
            return Range(2...3).randomElement()!
        }
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            if images.isEmpty {
                HStack (spacing: 0) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                }
                .frame(width: 180, height: 173)
                .cornerRadius(10)
            } else {
                switch id {
                case 1:
                    HStack (spacing: 0) {
                        ImageItemView(index: 0, images: images)
                    }
                    .frame(width: 180)
                    .cornerRadius(10)
                case 2:
                    HStack (spacing: 0) {
                        ImageItemView(index: 0, images: images)

                        VStack (spacing: 0) {
                            ImageItemView(index: 1, images: images)

                            ImageItemView(index: 2, images: images)

                        }
                    }
                    .frame(width: 180)
                    .cornerRadius(10)
                default:
                    HStack (spacing: 0) {
                        VStack (spacing: 0) {
                            ImageItemView(index: 0, images: images)

                            ImageItemView(index: 1, images: images)

                        }
                        ImageItemView(index: 2, images: images)

                    }
                    .frame(width: 180)
                    .cornerRadius(10)
                }
            }
            VStack (alignment: .leading) {
                Text(project.unwrappedName)
                    .fontWeight(.semibold)
                Text("^[\(images.count) Item](inflect:true)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ProjectSquareView(project: Project(), images: [])
}
