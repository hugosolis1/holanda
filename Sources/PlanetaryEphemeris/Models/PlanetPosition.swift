import Foundation

struct PlanetPosition: Identifiable {
    let id = UUID()
    let planet: Planet
    let degree: Double
    let speed: Double
    let isRetrograde: Bool
    
    var formattedDegree: String {
        String(format: "%.5f", degree)
    }
    
    var formattedSpeed: String {
        let sign = speed >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.5f", speed))"
    }
}
