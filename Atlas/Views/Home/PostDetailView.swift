//
//  PostDetailView.swift
//  Atlas
//
//  Created by Michael Bautista on 11/1/24.
//

import SwiftUI

struct PostDetailView: View {
    
    @StateObject var viewModel: PostDetailViewModel
    
    var body: some View {
        List {
            Section {
                VStack {
                    HStack(alignment: .top, spacing: 10) {
                        if viewModel.post.users?.profilePictureUrl != nil {
                            AsyncImage(url: URL(string: viewModel.post.users!.profilePictureUrl!)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 40, height: 40)
                                    .background(Color.ColorSystem.systemGray5)
                                    .clipShape(Circle())
                                    .tint(Color.ColorSystem.primaryText)
                            }
                        } else {
                            VStack {
                                Image(systemName: "person.circle.fill")
                                    .foregroundStyle(Color.ColorSystem.systemGray)
                            }
                            .frame(width: 40, height: 40)
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.post.users?.fullName ?? "")
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                                .lineLimit(1)
                            
                            Text(viewModel.post.calculateDate())
                                .font(Font.FontStyles.footnote)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                        }
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(viewModel.post.text ?? "")
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            
                            Spacer()
                        }
                        
                        if viewModel.post.workouts != nil {
                            WorkoutCell(title: viewModel.post.workouts!.title, description: viewModel.post.workouts!.description ?? "")
                        } else if viewModel.post.programs != nil {
                            ProgramCell(title: viewModel.post.programs!.title, imageUrl: viewModel.post.programs!.imageUrl, userFullName: viewModel.post.users!.fullName)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.ColorSystem.systemBackground)
    }
}

#Preview {
    PostDetailView(viewModel: PostDetailViewModel(post: Post(id: "17b69958-2c32-40dd-80f9-ba5aca650f18", createdAt: "2024-10-30T20:32:06.634412+00:00", createdBy: "e4d6f88c-d8c3-4a01-98d6-b5d56a366491", text: Optional("Test 5"), workoutId: nil, programId: nil, users: Optional(Atlas.FetchedUser(fullName: "Test Seller", profilePictureUrl: Optional("https://ltjnvfgpomlatmtqjxrk.supabase.co/storage/v1/object/public/profile_pictures/e4d6f88c-d8c3-4a01-98d6-b5d56a366491/2024-10-31T17:56:30.751Z.jpg"))), workouts: nil, programs: nil)))
}
