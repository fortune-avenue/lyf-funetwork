//
//  LocationAttributes.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import ActivityKit
import SwiftUI

struct LocationAttributes: ActivityAttributes {
    public typealias LocationActivityStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var locationName: LocationEnum
        var proximity: String
        var timestamp: Date
    }
    
    var userName: String
}
