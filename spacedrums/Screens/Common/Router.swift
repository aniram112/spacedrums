import Combine
import Foundation
import SwiftUI

class Router: ObservableObject {
    // Contains the possible destinations in our Router
    enum Route: Hashable {
        case main
        case saved
        case collection(sound: SoundViewModel)
        case addSound(mode: AddSoundMode, pitch: Int)
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
        case .collection(let sound):
            CollectionView(currentSound: sound)
        case .addSound(let mode, let pitch):
            AddSoundView(mode: mode, pitch: pitch)
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
    @StateObject var soundSpace = SoundSpaceModel()

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
        .environmentObject(router)
        .environmentObject(soundSpace)
        //.environment(\.colorScheme, .light)

        //.navigationBarHidden(true)
    }
}

struct ContentView: View {
    var body: some View {
        RouterView {
            //MainView()
            SavedView()
            //AddSoundView(mode: .listening, pitch: 220)
           //CollectionView(currentSound: .init(file: .mock, volume: 80, isActive: true, pitch: 220))
        }
    }
}
