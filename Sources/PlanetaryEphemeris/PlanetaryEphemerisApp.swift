import SwiftUI

@main
struct PlanetaryEphemerisApp: App {
    init() {
        SwissEphemerisWrapper.shared.initialize()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
