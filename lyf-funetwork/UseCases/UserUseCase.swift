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
        client = Supa.shared.client
    }
    
    func updateUserLocation(newLoc: LocationEnum) async {
        do {
             var a = try await client
                .from("user_location")
                .update([
                    "location": newLoc.rawValue,
                ])
                .eq("id", value: 2)
                .execute()
            
            print(a.response)
            
        } catch {
            print("Failed to update UserLocation: \(error)")
        }
    }
    
    // Read (fetch) a user by ID
    func getUserLocation() async -> [UserLocation]? {
        do {
            let user : [UserLocation] = try await client
                .from("user_location")
                .select("id, location, photo_profile")
                .execute()
                .value
            
            print("response", user)
            return user
        } catch {
            print("Failed to fetch User: \(error)")
            return nil
        }
    }
   
}

