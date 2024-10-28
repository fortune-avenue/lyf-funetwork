//
//  User.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 24/10/24.
//

import Foundation

class UserViewModel : ObservableObject {
    @Published var user: User?
    
    init() {
        self.user = userA
    }
    
    var userA : User {
        return User(name: "AnjingHitam11", photo_profile: "https://qcmgdvvckpzlcrlavaee.supabase.co/storage/v1/object/public/photo/1.png")
    }
    
    var userB : User {
        return User(name: "HiuBiru69", photo_profile: "https://qcmgdvvckpzlcrlavaee.supabase.co/storage/v1/object/public/photo/2.png")
    }
}
