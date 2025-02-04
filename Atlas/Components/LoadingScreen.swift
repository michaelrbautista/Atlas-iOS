//
//  LoadingScreen.swift
//  Atlas
//
//  Created by Michael Bautista on 1/29/25.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            ProgressView()
                .frame(maxWidth: UIScreen.main.bounds.size.width)
                .tint(Color.ColorSystem.primaryText)
            Spacer()
        }
        .background(Color.ColorSystem.systemBackground)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LoadingScreen()
}
