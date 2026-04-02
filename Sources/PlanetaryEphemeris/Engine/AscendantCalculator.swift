import Foundation
import SwissEphemeris

class AscendantCalculator {
    static let shared = AscendantCalculator()
    
    private init() {}
    
    func calculate(
        date: Date,
        latitude: Double = Location.greenwich.latitude,
        longitude: Double = Location.greenwich.longitude
    ) -> HouseCusps? {
        return try? HouseCusps(
            date: date,
            latitude: latitude,
            longitude: longitude,
            houseSystem: .placidus
        )
    }
    
    func calculateWithCustomLocation(
        date: Date,
        latitude: Double,
        longitude: Double
    ) -> HouseCusps? {
        return try? HouseCusps(
            date: date,
            latitude: latitude,
            longitude: longitude,
            houseSystem: .placidus
        )
    }
}
