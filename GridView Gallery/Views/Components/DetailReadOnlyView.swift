//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

struct DetailReadOnlyView: View {
    let img: ImageItem
    
    var body: some View {
        Section {
            HStack {
                Text("Project")
                Spacer()
                Text(img.project?.name ?? "None")
            }
            .pickerStyle(.navigationLink)
            .font(.subheadline)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.strokeBorder, lineWidth: 1)
            }

            VStack (alignment: .leading) {
                Text("Tags")
                    .fontWeight(.semibold)
                
                FlowLayout(mode: .scrollable, items: ["#tag", "#tag2"], itemSpacing: 4) {
                    Text($0)
                        .font(.subheadline)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColorInverted.opacity(0.5))
                        .cornerRadius(20)
                }
                .padding(.horizontal, 4)
                .frame(maxWidth: .infinity, minHeight: 75)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.strokeBorder, lineWidth: 1)
                }

            }
            
            VStack (alignment: .leading) {
                Text("Description")
                    .fontWeight(.semibold)
                
                Text(img.fulldescription ?? "")
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    .padding(.horizontal, 4)
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.strokeBorder, lineWidth: 1)
                    }
            }
        }
        .padding()
    }
}
