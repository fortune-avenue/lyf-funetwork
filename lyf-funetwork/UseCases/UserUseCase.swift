//
//  UserUseCase.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 24/10/24.
//

import Supabase
import Foundation
import Combine


class UserUseCase {
    // Singleton instance
    static let shared = UserUseCase()
    private let client: SupabaseClient
    
    // Private initializer to prevent instantiation
    private init() {
        // Access the shared Supabase client from the Supa singleton
        client = Supa.shared.client
    }
    
    // Read (fetch) a user by ID
    func getUser(byID id: Int8) async -> User? {
        do {
            var user : [User] = try await client
                .from("user")
                .select("id, name")
                .execute()
                .value
            
            return user[0]
        } catch {
            return nil
        }
    }
   
}

