//
//  UserView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct CreatorView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Image(systemName: "text.book.closed.fill")
                }
                .environmentObject(userViewModel)
        }
        .tint(Color.ColorSystem.primaryText)
    }
}

#Preview {
    UserView()
        .environmentObject(UserViewModel())
}
