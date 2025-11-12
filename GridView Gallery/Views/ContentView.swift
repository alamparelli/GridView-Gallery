//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    
    var body: some View {
        VStack {
            Text("Test AccentColor")
                .gridViewColors()
            Text("Inverted AccentColor")
                .gridViewColorsInverted()
            
            Button("Debug") {
                ns.navigate(to: .debug)
            }
            .buttonStyle(.glass)
        }
        .navigationTitle("Home")
        
    }
}

#Preview {
    ContentView()
}
