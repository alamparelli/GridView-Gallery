//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct DebugView: View {
    @State private var showImagePicker = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Debug")
                .font(.largeTitle)
            
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(
                        Text("No image captured")
                            .foregroundColor(.secondary)
                    )
            }
            
            Button(action: {
                showImagePicker = true
            }) {
                Label("Take Picture", systemImage: "camera.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePickerView(image: $capturedImage)
                .ignoresSafeArea()
        }
    }
}

//#Preview {
//    DebugView()
//}
