import Foundation
import SwissEphemeris

enum CalculationMode: String, CaseIterable, Identifiable {
    case geocentric = "Geocentric"
    case heliocentric = "Heliocentric"
    
    var id: String { rawValue }
}

enum Planet: String, CaseIterable, Identifiable {
    case sun = "Sun"
    case moon = "Moon"
    case mercury = "Mercury"
    case venus = "Venus"
    case mars = "Mars"
    case jupiter = "Jupiter"
    case saturn = "Saturn"
    case uranus = "Uranus"
    case neptune = "Neptune"
    case pluto = "Pluto"
    case trueNode = "True Node"
    case meanNode = "Mean Node"
    case ascendant = "ASC"
    case mc = "MC"
    case desc = "DESC"
    case ic = "IC"
    
    var id: String { rawValue }
    
    var swissPlanet: SwissEphemeris.Planet {
        switch self {
        case .sun: return .sun
        case .moon: return .moon
        case .mercury: return .mercury
        case .venus: return .venus
        case .mars: return .mars
        case .jupiter: return .jupiter
        case .saturn: return .saturn
        case .uranus: return .uranus
        case .neptune: return .neptune
        case .pluto: return .pluto
        case .trueNode, .meanNode, .ascendant, .mc, .desc, .ic:
            return .sun
        }
    }
    
    var iplNumber: Int32 {
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
        case .ascendant, .mc, .desc, .ic:
            return -1
        }
    }
    
    static var planetaryBodies: [Planet] {
        [.sun, .moon, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune, .pluto, .trueNode, .meanNode]
    }
}
