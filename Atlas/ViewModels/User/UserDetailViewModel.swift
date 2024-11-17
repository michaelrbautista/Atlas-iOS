//
//  UserDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import SwiftUI

final class UserDetailViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var isJoining = false
    
    @Published var didReturnError = false
    @Published var errorMessage: String? = nil
    
    @Published var user: User?
    
    @Published var isJoined = false
    
    @Published var userImage: UIImage? = nil
    @Published var userImageIsLoading = false
    
    init(userId: String) {
        Task {
            await getUser(userId: userId)
        }
    }
    
    @MainActor
    public func joinTeam() async {
        self.isJoining = true
        
//        guard let currentUserId = UserService.currentUser?.id else {
//            self.isJoining = false
//            self.didReturnError = true
//            self.errorMessage = "Couldn't get current user."
//            return
//        }
//        
//        let joinedTeam = JoinedTeam(
//            userId: currentUserId,
//            teamId: self.team!.id,
//            tier: "free"
//        )
//        
//        do {
//            try await TeamService.shared.joinTeam(joinedTeam: joinedTeam)
//            
//            self.isJoined = true
//            self.isJoining = false
//        } catch {
//            self.didReturnError = true
//            self.errorMessage = "Couldn't join team."
//            return
//        }
    }
    
    @MainActor
    public func getUser(userId: String) async {
//        do {
//            let team = try await TeamService.shared.getTeam(teamId: teamId)
//            
//            // Check if user has already purchased the program
//            let isJoined = try await TeamService.shared.checkIfUserJoinedTeam(teamId: team.id)
//            
//            self.team = team
//            self.isJoined = isJoined
//            
//            if team.imageUrl != nil {
//                self.teamImageIsLoading = true
//                
//                self.getImage(imageUrl: team.imageUrl!) { error in
//                    self.teamImageIsLoading = false
//                    
//                    if let error = error {
//                        self.didReturnError = true
//                        self.errorMessage = error.localizedDescription
//                        return
//                    }
//                }
//            }
//            
//            self.isLoading = false
//        } catch {
//            self.isLoading = false
//            self.didReturnError = true
//            self.errorMessage = error.localizedDescription
//        }
    }
    
    // MARK: Get user iamge
    public func getImage(imageUrl: String, completion: @escaping (_ error: Error?) -> Void) {
        guard let fetchUrl = URL(string: imageUrl) else {
            print("Couldn't get image from URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: fetchUrl) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    self.userImage = image
                    completion(nil)
                } else {
                    print("Couldn't get image from data.")
                    return
                }
            }
        }
        
        task.resume()
    }
}
