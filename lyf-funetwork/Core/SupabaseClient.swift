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
            supabaseURL: URL(string: "https://qcmgdvvckpzlcrlavaee.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjbWdkdnZja3B6bGNybGF2YWVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk3MDExNjEsImV4cCI6MjA0NTI3NzE2MX0.DLcB2O3s2gnpewoW1xVM-bXqUkRN0-vClXy3Rh5rDfM"
        )
    }
}

