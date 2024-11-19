//
//  TeamService.swift
//  Atlas
//
//  Created by Michael Bautista on 9/8/24.
//

import Foundation

import SwiftUI

final class TeamService {
    
    public static let shared = TeamService()
    
    // MARK: Check if team has been joined
    public func checkIfUserJoinedTeam(teamId: String) async throws -> Bool {
        guard let currentUser = UserService.currentUser else {
            return false
        }
        
        do {
            let teams: [JoinedTeam] = try await SupabaseService.shared.supabase
                .from("joined_teams")
                .select()
                .eq("team_id", value: teamId)
                .eq("user_id", value: currentUser.id)
                .execute()
                .value
            
            return teams.count > 0
        } catch {
            throw error
        }
    }
    
    // MARK: Join team
    public func joinTeam(joinedTeam: JoinedTeam) async throws {
        do {
            try await SupabaseService.shared.supabase
                .from("joined_teams")
                .insert(joinedTeam)
                .execute()
        } catch {
            throw error
        }
    }
    
    // MARK: Search teams
    public func searchTeams(searchText: String) async throws -> [Team] {
        do {
            let teams: [Team] = try await SupabaseService.shared.supabase
                .from("teams")
                .select()
                .textSearch("name", query: "'\(searchText)'")
                .execute()
                .value
            
            return teams
        } catch {
            throw error
        }
    }
    
    // MARK: Get joined teams
    public func getJoinedTeams(userId: String) async throws -> [JoinedTeam] {
        do {
            let teams: [JoinedTeam] = try await SupabaseService.shared.supabase
                .from("joined_teams")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value
            
            return teams
        } catch {
            throw error
        }
    }
    
    // MARK: Get team
    public func getTeam(teamId: String) async throws -> Team {
        do {
            let team: Team = try await SupabaseService.shared.supabase
                .from("teams")
                .select()
                .eq("id", value: teamId)
                .single()
                .execute()
                .value
            
            return team
        } catch {
            throw error
        }
    }

    // MARK: Get user's saved programs
    public func getTeams() async throws -> [Team] {
        do {
            let teams: [Team] = try await SupabaseService.shared.supabase
                .from("teams")
                .select()
                .execute()
                .value
            
            return teams
        } catch {
            throw error
        }
    }
    
}
