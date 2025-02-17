//
//  SubscribeButton.swift
//  Atlas
//
//  Created by Michael Bautista on 2/15/25.
//

import SwiftUI

struct SubscribeButton: View {
    @EnvironmentObject var navigationController: NavigationController
    var viewModel: UserDetailViewModel
    @Binding var isSubscribed: Bool
    @Binding var isSubscribing: Bool
    
    var body: some View {
        // MARK: Subscribed
        if isSubscribed {
            Button {
                Task {
                    await viewModel.unsubscribeFromUser()
                }
            } label: {
                HStack {
                    Spacer()
                    if isSubscribing {
                        ProgressView()
                            .frame(maxWidth: UIScreen.main.bounds.size.width)
                            .tint(Color.ColorSystem.primaryText)
                    } else {
                        Text("Unsubscribe")
                            .font(Font.FontStyles.headline)
                            .foregroundStyle(Color.ColorSystem.systemGray)
                    }
                    Spacer()
                }
                .frame(height: 40)
                .background(Color.ColorSystem.systemGray5)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            .listRowSeparator(.hidden)
            .buttonStyle(.plain)
        } else {
            // MARK: Not subscribed
            Button {
                Task {
                    await viewModel.subscribeToUser()
                    
                    navigationController.presentSheet(.SubscribeSheet)
                }
            } label: {
                HStack {
                    Spacer()
                    if isSubscribing {
                        ProgressView()
                            .frame(maxWidth: UIScreen.main.bounds.size.width)
                            .tint(Color.ColorSystem.primaryText)
                    } else {
                        Text("Subscribe")
                            .font(Font.FontStyles.headline)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    }
                    Spacer()
                }
                .frame(height: 40)
                .background(Color.ColorSystem.systemBlue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            .listRowSeparator(.hidden)
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    VStack {
        SubscribeButton(viewModel: UserDetailViewModel(userId: ""), isSubscribed: .constant(true), isSubscribing: .constant(false))
        SubscribeButton(viewModel: UserDetailViewModel(userId: ""), isSubscribed: .constant(true), isSubscribing: .constant(true))
    }
}
