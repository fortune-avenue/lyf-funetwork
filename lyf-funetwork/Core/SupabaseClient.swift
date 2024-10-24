//
//  SupabaseCliet.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 24/10/24.
//
import Supabase
import Foundation
import SwiftUI
import Combine

class Supa: ObservableObject {
    static let shared = Supa()
    let client: SupabaseClient
    
    private init() {
        // Initialize the Supabase client with your URL and API key
        client = SupabaseClient(
            supabaseURL: URL(string: "https://icpuzvxjqusersaheege.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImljcHV6dnhqcXVzZXJzYWhlZWdlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk2ODI4NDgsImV4cCI6MjA0NTI1ODg0OH0.pCbDNVs-m8tHAD22ZEAMfd1d7q0QXxUOY-teWq6dMHY"
        )
    }
}

