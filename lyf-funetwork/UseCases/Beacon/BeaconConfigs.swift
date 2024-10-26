//
//  BeaconConfigs.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import Foundation

let LyfBeaconConfigs = [
    BeaconConfig(
        name: "gym",
        uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!,
        segments: [
            BeaconConfig.BeaconSegment(name: .gymA, major: 1, minor: 1),
            BeaconConfig.BeaconSegment(name: .gymB, major: 1, minor: 2),
            BeaconConfig.BeaconSegment(name: .gymC, major: 1, minor: 3)
        ]
    ),
    BeaconConfig(
        name: "kitchen",
        uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!,
        segments: [
            BeaconConfig.BeaconSegment(name: .kitchen, major: 1, minor: 1)
        ]
    ),
    BeaconConfig(
        name: "laundry",
        uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!,
        segments: [
            BeaconConfig.BeaconSegment(name: .laundry, major: 1, minor: 1)
        ]
    ),
    
    BeaconConfig(
        name: "coworking",
        uuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        segments: [
            BeaconConfig.BeaconSegment(name: .coworkingA, major: 1, minor: 1),
            BeaconConfig.BeaconSegment(name: .coworkingB, major: 1, minor: 2),
            BeaconConfig.BeaconSegment(name: .coworkingC, major: 1, minor: 3)
        ]
    )
]
