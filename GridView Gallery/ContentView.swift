//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        VStack {
            Text("Test AccentColor")
                .gridViewColors()
            Text("Inverted AccentColor")
                .gridViewColorsInverted()
        }
        .navigationTitle("Home")
    }
}

#Preview {
    ContentView()
}
