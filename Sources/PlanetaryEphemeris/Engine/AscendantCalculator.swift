import Foundation

class AscendantCalculator {
    static let shared = AscendantCalculator()
    
    private let swissEphemeris = SwissEphemerisWrapper.shared
    
    private init() {}
    
    func calculate(
        date: Date,
        latitude: Double = Location.greenwich.latitude,
        longitude: Double = Location.greenwich.longitude
    ) -> HouseCusps? {
        let jd = swissEphemeris.dateToJulianDay(date)
        
        return swissEphemeris.calculateHouses(
            julianDay: jd,
            latitude: latitude,
            longitude: longitude
        )
    }
    
    func calculateWithCustomLocation(
        date: Date,
        latitude: Double,
        longitude: Double
    ) -> HouseCusps? {
        let jd = swissEphemeris.dateToJulianDay(date)
        
        return swissEphemeris.calculateHouses(
            julianDay: jd,
            latitude: latitude,
            longitude: longitude
        )
    }
}
