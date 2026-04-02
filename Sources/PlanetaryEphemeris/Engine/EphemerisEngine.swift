import Foundation

class EphemerisEngine {
    static let shared = EphemerisEngine()
    
    private let swissEphemeris = SwissEphemerisWrapper.shared
    private let location = Location.greenwich
    
    private init() {
        swissEphemeris.initialize()
    }
    
    func calculateAllPlanetPositions(
        date: Date,
        mode: CalculationMode
    ) -> [PlanetPosition] {
        let jd = swissEphemeris.dateToJulianDay(date)
        let isHeliocentric = mode == .heliocentric
        
        var positions: [PlanetPosition] = []
        
        for planet in Planet.allCases {
            if let position = calculatePlanetPosition(
                planet: planet,
                julianDay: jd,
                isHeliocentric: isHeliocentric
            ) {
                positions.append(position)
            }
        }
        
        return positions
    }
    
    func calculatePlanetPosition(
        planet: Planet,
        date: Date,
        mode: CalculationMode
    ) -> PlanetPosition? {
        let jd = swissEphemeris.dateToJulianDay(date)
        let isHeliocentric = mode == .heliocentric
        
        return calculatePlanetPosition(planet: planet, julianDay: jd, isHeliocentric: isHeliocentric)
    }
    
    private func calculatePlanetPosition(
        planet: Planet,
        julianDay: Double,
        isHeliocentric: Bool
    ) -> PlanetPosition? {
        guard let result = swissEphemeris.calculatePlanetPosition(
            planet: planet,
            julianDay: julianDay,
            isHeliocentric: isHeliocentric
        ) else {
            return nil
        }
        
        return PlanetPosition(
            planet: planet,
            longitude: result.longitude,
            latitude: result.latitude,
            distance: result.distance,
            speed: result.speed,
            julianDay: julianDay,
            isHeliocentric: isHeliocentric
        )
    }
    
    func calculateAscendantMC(date: Date) -> HouseCusps? {
        let jd = swissEphemeris.dateToJulianDay(date)
        
        return swissEphemeris.calculateHouses(
            julianDay: jd,
            latitude: location.latitude,
            longitude: location.longitude
        )
    }
    
    func calculatePositions(
        planet: Planet,
        date: Date,
        mode: CalculationMode
    ) -> Double? {
        let jd = swissEphemeris.dateToJulianDay(date)
        let isHeliocentric = mode == .heliocentric
        
        guard let result = swissEphemeris.calculatePlanetPosition(
            planet: planet,
            julianDay: jd,
            isHeliocentric: isHeliocentric
        ) else {
            return nil
        }
        
        return normalizeDegree(result.longitude)
    }
    
    private func normalizeDegree(_ degree: Double) -> Double {
        var result = degree.truncatingRemainder(dividingBy: 360)
        if result < 0 {
            result += 360
        }
        return result
    }
}
