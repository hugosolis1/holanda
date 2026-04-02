import Foundation

enum Planet: Int, CaseIterable, Identifiable {
    case sun = 0
    case moon = 1
    case mercury = 2
    case venus = 3
    case mars = 4
    case jupiter = 5
    case saturn = 6
    case uranus = 7
    case neptune = 8
    case pluto = 9
    case trueNode = 10
    case meanNode = 11
    
    var id: Int { rawValue }
    
    var name: String {
        switch self {
        case .sun: return "Sun"
        case .moon: return "Moon"
        case .mercury: return "Mercury"
        case .venus: return "Venus"
        case .mars: return "Mars"
        case .jupiter: return "Jupiter"
        case .saturn: return "Saturn"
        case .uranus: return "Uranus"
        case .neptune: return "Neptune"
        case .pluto: return "Pluto"
        case .trueNode: return "True Node"
        case .meanNode: return "Mean Node"
        }
    }
    
    var swissEphemerisIndex: Int32 {
        switch self {
        case .sun: return 0
        case .moon: return 1
        case .mercury: return 2
        case .venus: return 3
        case .mars: return 4
        case .jupiter: return 5
        case .saturn: return 6
        case .uranus: return 7
        case .neptune: return 8
        case .pluto: return 9
        case .trueNode: return 10
        case .meanNode: return 11
        }
    }
    
    static var searchablePlanets: [Planet] {
        return allCases
    }
}

struct PlanetPosition: Identifiable {
    let id = UUID()
    let planet: Planet
    let longitude: Double
    let latitude: Double
    let distance: Double
    let speed: Double
    let julianDay: Double
    let isHeliocentric: Bool
    
    var isRetrograde: Bool {
        return speed < 0
    }
    
    var formattedLongitude: String {
        let normalized = normalizeDegree(longitude)
        return String(format: "%.5f°", normalized)
    }
    
    var formattedDegree: String {
        let normalized = normalizeDegree(longitude)
        return String(format: "%.5f", normalized)
    }
    
    private func normalizeDegree(_ degree: Double) -> Double {
        var result = degree.truncatingRemainder(dividingBy: 360)
        if result < 0 {
            result += 360
        }
        return result
    }
}

enum CalculationMode: String, CaseIterable {
    case geocentric = "Geocentric"
    case heliocentric = "Heliocentric"
}

struct Location {
    let latitude: Double
    let longitude: Double
    
    static let greenwich = Location(latitude: 51.4769, longitude: 0.0005)
}

struct HouseCusps {
    let ascendant: Double
    let mc: Double
    let descendant: Double
    let ic: Double
    
    var formattedAscendant: String {
        return String(format: "%.5f°", normalizeDegree(ascendant))
    }
    
    var formattedMC: String {
        return String(format: "%.5f°", normalizeDegree(mc))
    }
    
    var formattedDescendant: String {
        return String(format: "%.5f°", normalizeDegree(descendant))
    }
    
    var formattedIC: String {
        return String(format: "%.5f°", normalizeDegree(ic))
    }
    
    private func normalizeDegree(_ degree: Double) -> Double {
        var result = degree.truncatingRemainder(dividingBy: 360)
        if result < 0 {
            result += 360
        }
        return result
    }
}

struct SearchResult: Identifiable {
    let id = UUID()
    let planet: Planet
    let degree: Double
    let date: Date
    
    var formattedDegree: String {
        return String(format: "%.5f°", degree)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm 'UTC'"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
}
