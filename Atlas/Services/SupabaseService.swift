//
//  SupabaseService.swift
//  Atlas
//
//  Created by Michael Bautista on 4/26/24.
//

import SwiftUI
import Supabase

final class SupabaseService {
    
    public static let shared = SupabaseService()
    public var supabase: SupabaseClient
    
    init() {
        self.supabase = SupabaseClient(
            supabaseURL: URL(string: "https://ltjnvfgpomlatmtqjxrk.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx0am52Zmdwb21sYXRtdHFqeHJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTQwOTgxMzAsImV4cCI6MjAyOTY3NDEzMH0.BahCtPc6pDoLHAtUeuLtO-krHmjTw3z6BbeFsJ6VIYM"
        )
    }
    
}
