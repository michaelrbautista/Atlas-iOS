//
//  PostCell.swift
//  Atlas
//
//  Created by Michael Bautista on 10/31/24.
//

import SwiftUI

struct PostCell: View {
    
    var post: Post
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(alignment: .top, spacing: 10) {
                if post.users?.profilePictureUrl != nil {
                    AsyncImage(url: URL(string: post.users!.profilePictureUrl!)) { image in
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
                    Text(post.users?.fullName ?? "")
                        .font(Font.FontStyles.headline)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .lineLimit(1)
                    
                    Text(post.calculateDate())
                        .font(Font.FontStyles.footnote)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                }
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(post.text ?? "")
                    
                    if post.workouts != nil {
                        WorkoutCell(title: post.workouts!.title, description: post.workouts!.description ?? "")
                    } else if post.programs != nil {
                        ProgramCell(title: post.programs!.title, imageUrl: post.programs!.imageUrl, userFullName: post.users!.fullName)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PostCell(post: Post(id: "17b69958-2c32-40dd-80f9-ba5aca650f18", createdAt: "2024-10-30T20:32:06.634412+00:00", createdBy: "e4d6f88c-d8c3-4a01-98d6-b5d56a366491", text: Optional("Test 5"), workoutId: Optional("63a346c6-87e2-4788-aeab-4417d15892c0"), programId: nil, users: Optional(Atlas.FetchedUser(fullName: "Test Seller", profilePictureUrl: Optional("https://ltjnvfgpomlatmtqjxrk.supabase.co/storage/v1/object/public/profile_pictures/e4d6f88c-d8c3-4a01-98d6-b5d56a366491/2024-10-31T17:56:30.751Z.jpg"))), workouts: Optional(Atlas.FetchedWorkout(id: "63a346c6-87e2-4788-aeab-4417d15892c0", title: "Test Workout Monday", description: Optional("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas fringilla quam ligula. Suspendisse egestas ultrices orci, ac fermentum dolor bibendum sit amet."))), programs: nil))
}
