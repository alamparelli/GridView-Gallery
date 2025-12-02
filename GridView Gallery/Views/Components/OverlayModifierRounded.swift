//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct OverlayModifierRounded: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.strokeBorder, lineWidth: 1)
            }
    }
}


extension View {
    func overlayModifierRounded() -> some View {
        self.modifier(OverlayModifierRounded())
    }
}
