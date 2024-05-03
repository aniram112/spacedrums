import Foundation
import SwiftUI
import Firebase

@main
struct DrumsApp: App {

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(.light)
            //TunerView()
        }
    }
}
