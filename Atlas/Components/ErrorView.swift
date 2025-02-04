//
//  ErrorView.swift
//  Atlas
//
//  Created by Michael Bautista on 2/2/25.
//

import SwiftUI

struct ErrorView: View {
    
    var errorMessage: String
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            
            Text("An error occured.")
                .font(Font.FontStyles.title1)
                .foregroundStyle(Color.ColorSystem.primaryText)
            
            #if DEBUG
            Text(errorMessage)
                .font(Font.FontStyles.body)
                .foregroundStyle(Color.ColorSystem.systemGray)
            #else
            Text("Please try again later.")
                .font(Font.FontStyles.body)
                .foregroundStyle(Color.ColorSystem.systemGray)
            #endif
            
            Spacer()
        }
    }
}

#Preview {
    ErrorView(errorMessage: "This is a test error.")
}
