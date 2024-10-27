//
//  UserLocation.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 24/10/24.
//

struct UserLocation: Encodable, Decodable {
    let id: Int
    let location: String
    let user: User
    
   
}

struct User : Encodable, Decodable {
    let name: String
}

struct Location : Encodable, Decodable {
    let location_id : LocationEnum
}


