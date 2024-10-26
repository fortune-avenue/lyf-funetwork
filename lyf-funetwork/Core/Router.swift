//
//  Router.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    enum Route: Hashable {
        case map
        case mapDetail
        case profile
        case notification
    }
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}
