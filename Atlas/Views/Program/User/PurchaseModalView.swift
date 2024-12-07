//
//  PurchaseModalView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/30/24.
//

import SwiftUI

struct PurchaseModalView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 5) {
            Text("Purchase Program")
                .font(Font.FontStyles.title3)
                .foregroundStyle(Color.ColorSystem.primaryText)
            
            Text("Purchases can't be made in the mobile app.")
                .font(Font.FontStyles.body)
                .foregroundStyle(Color.ColorSystem.systemGray)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Spacer()
                    
                    Text("Okay")
                        .font(Font.FontStyles.headline)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                    
                    Spacer()
                }
                .padding(10)
            }
            .background(Color.ColorSystem.systemGray5)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(10)
            
            Spacer()
        }
        .background(Color.ColorSystem.systemGray6)
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
    }
}

#Preview {
    PurchaseModalView()
}
