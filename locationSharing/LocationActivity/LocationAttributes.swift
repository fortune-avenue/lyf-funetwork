//
//  LocationAttributes.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import ActivityKit
import SwiftUI
import CoreLocation

struct LocationAttributes: ActivityAttributes {
    public typealias LocationActivityStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var locationName: LocationEnum
        var proximity: CLProximity
        var accuracy : CLLocationAccuracy
        var timestamp: Date
    }
    
    var userName: String
}

extension CLProximity: Codable {
}
