//
//  SubscribeSheet.swift
//  Atlas
//
//  Created by Michael Bautista on 1/24/25.
//

import SwiftUI

struct SubscribeSheet: View {
    @EnvironmentObject var navigationController: NavigationController
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Manage subscription")
                    .font(Font.FontStyles.title1)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                
                Text("You cannot manage your subscription in the app.")
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.systemGray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
            
            Button {
                navigationController.dismissSheet()
            } label: {
                HStack {
                    Spacer()
                    Text("Okay")
                        .font(Font.FontStyles.headline)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                    Spacer()
                }
                .padding(10)
                .background(Color.ColorSystem.systemGray5)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            Spacer()
        }
        .background(Color.ColorSystem.systemBackground)
    }
}

#Preview {
    SubscribeSheet()
}
