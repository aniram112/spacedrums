import Combine
import Foundation
import SwiftUI

class Router: ObservableObject {
    // Contains the possible destinations in our Router
    enum Route: Hashable {
        case main
        case saved
        case collection
        case addSound(mode: AddSoundMode)
    }

    // Used to programatically control our navigation stack
    @Published var path: NavigationPath = NavigationPath()

    // Builds the views
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .main:
            MainView()
        case .saved:
            SavedView()
        case .collection:
           CollectionView()
        case .addSound(let mode):
            AddSoundView(mode: mode)
        }
    }

    // Used by views to navigate to another view
    func routeTo(_ appRoute: Route) {
        path.append(appRoute)
    }

    // Used to go back to the previous screen
    func routeBack() {
            path.removeLast()
    }

    // Pop to the root screen in our hierarchy
    func popToRoot() {
        path.removeLast(path.count)
    }
}

struct RouterView<Content: View>: View {
    @StateObject var router: Router = Router()
    // Our root view content
    private let content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                }
        }.accentColor(.white)
        .toolbarBackground(Color.pink, for: .navigationBar)
        .environmentObject(router)

        //.navigationBarHidden(true)
    }
}

struct ContentView: View {
    var body: some View {
        RouterView {
            MainView()
        }
    }
}
