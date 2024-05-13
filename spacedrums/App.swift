import Foundation
import SwiftUI
import Firebase
import UIKit
import Pulse


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let messages = try? LoggerStore.shared.allMessages()
        guard let mes = messages else {return true}
        for m in mes {
            print("yeet \(m.createdAt) \(m.label)")
        }
        return true
    }
}

@main
struct DrumsApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(.light)
        }
    }
}
