//
//  ExploreViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 10/4/24.
//

import SwiftUI
import Combine

final class ExploreViewModel: ObservableObject {
    
    @Published var searchText = ""
    var subscriptions = Set<AnyCancellable>()
    
    @Published var allUsers = [User]()
    
    @Published var users = [User]()
    @Published var programs = [Program]()
    
    var filters = ["Programs", "Users"]
    @Published var filter = "Users"
    
    @Published var isLoading = true
    
    @Published var didReturnError = false
    @Published var errorMessage = ""
    
    @MainActor
    public func getAllUsers() async {
        do {
            let allUsers = try await UserService.shared.getAllUsers()
            
            self.allUsers = allUsers
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    public func search() async {
        self.isLoading = true
        
        if filter == "Programs" {
            do {
                let programs = try await ProgramService.shared.searchPrograms(searchText: searchText)
                
                self.programs = programs
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.didReturnError = true
                self.errorMessage = error.localizedDescription
            }
        } else {
            do {
                let users = try await UserService.shared.searchUsers(searchText: searchText)

                self.users = users
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.didReturnError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
