import Foundation
import SwissEphemeris

class EphemerisEngine {
    static let shared = EphemerisEngine()
    
    private let location = Location.greenwich
    
    private init() {
        JPLFileManager.setEphemerisPath()
    }
    
    func calculateAllPlanetPositions(
        date: Date,
        mode: CalculationMode
    ) -> [PlanetPosition] {
        let calcMode: SwissEphemeris.CalculationMode
        switch mode {
        case .geocentric:
            calcMode = .swiss
        case .heliocentric:
            calcMode = [.swiss, .heliocentric]
        }
        
        var positions: [PlanetPosition] = []
        
        for planet in Planet.allCases {
            let coordinate = Coordinate(planet: planet.swissPlanet, date: date, calculationMode: calcMode)
            
            positions.append(PlanetPosition(
                planet: planet,
                longitude: coordinate.longitude,
                latitude: coordinate.latitude,
                distance: coordinate.distance,
                speed: coordinate.speedLongitude
            ))
        }
        
        if let houses = calculateHouses(date: date) {
            positions.append(contentsOf: houses)
        }
        
        return positions
    }
    
    func calculatePlanetPosition(
        planet: Planet,
        date: Date,
        mode: CalculationMode
    ) -> PlanetPosition? {
        let calcMode: SwissEphemeris.CalculationMode
        switch mode {
        case .geocentric:
            calcMode = .swiss
        case .heliocentric:
            calcMode = [.swiss, .heliocentric]
        }
        
        let coordinate = Coordinate(planet: planet.swissPlanet, date: date, calculationMode: calcMode)
        
        return PlanetPosition(
            planet: planet,
            longitude: coordinate.longitude,
            latitude: coordinate.latitude,
            distance: coordinate.distance,
            speed: coordinate.speedLongitude
        )
    }
    
    private func calculateHouses(date: Date) -> [PlanetPosition]? {
        guard let houses = try? HouseCusps(
            date: date,
            latitude: location.latitude,
            longitude: location.longitude,
            houseSystem: .placidus
        ) else {
            return nil
        }
        
        return [
            PlanetPosition(planet: Planet(rawValue: -1)!, longitude: houses.ascendant.tropical.degree, latitude: 0, distance: 0, speed: 0),
            PlanetPosition(planet: Planet(rawValue: -1)!, longitude: houses.mc.tropical.degree, latitude: 0, distance: 0, speed: 0),
            PlanetPosition(planet: Planet(rawValue: -1)!, longitude: houses.descendant.tropical.degree, latitude: 0, distance: 0, speed: 0),
            PlanetPosition(planet: Planet(rawValue: -1)!, longitude: houses.ic.tropical.degree, latitude: 0, distance: 0, speed: 0)
        ]
    }
    
    func calculatePositions(
        planet: Planet,
        date: Date,
        mode: CalculationMode
    ) -> Double? {
        let calcMode: SwissEphemeris.CalculationMode
        switch mode {
        case .geocentric:
            calcMode = .swiss
        case .heliocentric:
            calcMode = [.swiss, .heliocentric]
        }
        
        let coordinate = Coordinate(planet: planet.swissPlanet, date: date, calculationMode: calcMode)
        return normalizeDegree(coordinate.longitude)
    }
    
    func calculateAscendantMC(date: Date) -> HouseCusps? {
        return try? HouseCusps(
            date: date,
            latitude: location.latitude,
            longitude: location.longitude,
            houseSystem: .placidus
        )
    }
    
    private func normalizeDegree(_ degree: Double) -> Double {
        var result = degree.truncatingRemainder(dividingBy: 360)
        if result < 0 {
            result += 360
        }
        return result
    }
}
