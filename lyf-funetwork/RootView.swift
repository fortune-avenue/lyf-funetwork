//
//  RootView.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var router = Router()
    @StateObject private var userVM = UserViewModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: Router.Route.self) { route in
                    switch route {
                    case .profile:
                        ProfileView()
                    case .notification:
                        NotificationView()
                    case .map:
                        EmptyView()
                    case .gym:
                        MapDetailView(location: .gym)
                    case .kitchen:
                        MapDetailView(location: .kitchen)
                    case .lounge:
                        MapDetailView(location: .lounge)
                    case .laundry:
                        MapDetailView(location: .laundry)
                    case .forum :
                        ForumView()
                    }
                }
        }.environmentObject(router)
    }
}

#Preview {
    RootView()
}
