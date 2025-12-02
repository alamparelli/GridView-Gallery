//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

/// View modifier that adds a rounded border overlay.
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
    /// Applies a rounded border overlay to the view.
    /// - Returns: View with rounded border.
    func overlayModifierRounded() -> some View {
        self.modifier(OverlayModifierRounded())
    }
}
