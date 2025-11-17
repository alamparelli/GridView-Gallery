//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

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
                .frame(minHeight: 150)
                .cornerRadius(10)
            } else {
                switch id {
                case 1:
                    HStack (spacing: 0) {
                        if let image = images[0].uiImage {
                            Image(uiImage: image )
                        }
                    }
                    .frame(minHeight: 150)
                    .cornerRadius(10)
                case 2:
                    HStack (spacing: 0) {
                        if let image = images[0].uiImage {
                            Image(uiImage: image )
                        }
                        VStack (spacing: 0) {
                            if let image = images[1].uiImage {
                                Image(uiImage: image )
                            }
                            if let image = images[2].uiImage {
                                Image(uiImage: image )
                            }
                        }
                    }
                    .frame(minHeight: 150)
                    .cornerRadius(10)
                default:
                    HStack (spacing: 0) {
                        VStack (spacing: 0) {
                            if let image = images[0].uiImage {
                                Image(uiImage: image )
                            }
                            if let image = images[1].uiImage {
                                Image(uiImage: image )
                            }
                        }
                        if let image = images[2].uiImage {
                            Image(uiImage: image )
                        }
                    }
                    .frame(minHeight: 150)
                    .cornerRadius(10)
                }
            }
            VStack (alignment: .leading) {
                Text(project.unwrappedName)
                    .fontWeight(.semibold)
                Text("\(images.count) Items")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ProjectSquareView(project: Project(), images: [])
}
