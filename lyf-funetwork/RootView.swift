//
//  RootView.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: Router.Route.self) { route in
                    switch route {
                    case .map : MapView()
                    case .mapDetail:
                        MapDetailView()
                    case .profile:
                        ProfileView()
                    case .notification:
                        NotificationView()
                    }
                }
        }
    }
}

#Preview {
    RootView()
}
