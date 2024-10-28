//
//  UserLocation.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 24/10/24.
//

struct UserLocation: Identifiable, Encodable, Decodable {
    let id: Int
    let location: String
    let photo_profile: String
}

struct User : Encodable, Decodable, Hashable {
    let name: String
    let photo_profile: String
}

struct Location : Encodable, Decodable {
    let location_id : LocationEnum
}


