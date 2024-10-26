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

enum LocationEnum : String, Encodable, Decodable {
    case none = "none"
    case gymA = "gymA"
    case gymB = "gymB"
    case gymC = "gymC"
    case kitchen = "kitchen"
    case coworkingA = "coworkingA"
    case coworkingB = "coworkingB"
    case coworkingC = "coworkingC"
    case laundry = "laundry"
}
