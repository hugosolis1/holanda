import Foundation

class SwissEphemerisWrapper {
    static let shared = SwissEphemerisWrapper()
    
    private var ephePath: String = ""
    private var isInitialized = false
    
    private init() {}
    
    func initialize() {
        guard !isInitialized else { return }
        
        if let bundlePath = Bundle.main.resourcePath {
            ephePath = bundlePath + "/ephe"
        } else {
            ephePath = "./ephe"
        }
        
        let result = swe_set_ephe_path(ephePath)
        if result == 0 {
            print("Swiss Ephemeris path set to: \(ephePath)")
            isInitialized = true
        } else {
            print("Warning: Failed to set ephemeris path, code: \(result)")
        }
    }
    
    func calculatePlanetPosition(
        planet: Planet,
        julianDay: Double,
        isHeliocentric: Bool
    ) -> (longitude: Double, latitude: Double, distance: Double, speed: Double)? {
        var xx: [Double] = [0, 0, 0, 0, 0, 0]
        var speed: [Double] = [0, 0, 0, 0, 0, 0]
        
        var iflag: Int32 = Int32(SEFLG_SPEED)
        
        if isHeliocentric {
            iflag |= Int32(SEFLG_HELCTR)
        }
        
        iflag |= Int32(SEFLG_SWIEPH)
        
        var errorMessage: UnsafeMutablePointer<CChar>?
        
        let result = swe_calc_ut(julianDay, planet.swissEphemerisIndex, iflag, &xx, &speed, &errorMessage)
        
        if result < 0 {
            if let error = errorMessage {
                print("Swiss Ephemeris error for \(planet.name): \(String(cString: error))")
            }
            return nil
        }
        
        return (longitude: xx[0], latitude: xx[1], distance: xx[2], speed: speed[0])
    }
    
    func calculateHouses(
        julianDay: Double,
        latitude: Double,
        longitude: Double
    ) -> HouseCusps? {
        var ascmc: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        let hSys: Int32 = Int32(SE_HOUSE_PLACIDIUS)
        
        let result = swe_houses(julianDay, latitude, longitude, hSys, &ascmc)
        
        if result < 0 {
            print("Failed to calculate houses")
            return nil
        }
        
        return HouseCusps(
            ascendant: ascmc[0],
            mc: ascmc[1],
            descendant: ascmc[2],
            ic: ascmc[3]
        )
    }
    
    func julianDay(
        year: Int32,
        month: Int32,
        day: Int32,
        hour: Double
    ) -> Double {
        var tjd: Double = 0
        var errorMessage: UnsafeMutablePointer<CChar>?
        
        swe_julday(year, month, day, hour, &tjd, &errorMessage)
        
        return tjd
    }
    
    func dateToJulianDay(_ date: Date) -> Double {
        let calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let year = Int32(calendar.component(.year, from: date))
        let month = Int32(calendar.component(.month, from: date))
        let day = Int32(calendar.component(.day, from: date))
        
        let hour = Double(calendar.component(.hour, from: date))
        let minute = Double(calendar.component(.minute, from: date))
        let second = Double(calendar.component(.second, from: date))
        
        let dayFraction = (hour + minute / 60.0 + second / 3600.0) / 24.0
        
        return julianDay(year: year, month: month, day: day, hour: dayFraction)
    }
    
    func julianDayToDate(_ tjd: Double) -> Date {
        var year: Int32 = 0
        var month: Int32 = 0
        var day: Int32 = 0
        var hour: Double = 0
        var errorMessage: UnsafeMutablePointer<CChar>?
        
        swe_revjul(tjd, &year, &month, &day, &hour, &errorMessage)
        
        let calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let totalSeconds = Int(hour * 3600)
        let hourInt = totalSeconds / 3600
        let minuteInt = (totalSeconds % 3600) / 60
        let secondInt = totalSeconds % 60
        
        var components = DateComponents()
        components.year = Int(year)
        components.month = Int(month)
        components.day = Int(day)
        components.hour = hourInt
        components.minute = minuteInt
        components.second = secondInt
        components.timeZone = TimeZone(identifier: "UTC")
        
        return calendar.date(from: components) ?? Date()
    }
}
