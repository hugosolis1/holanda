import Foundation

class DegreeSearchEngine: ObservableObject {
    static let shared = DegreeSearchEngine()
    
    private let ephemerisEngine = EphemerisEngine.shared
    private let swissEphemeris = SwissEphemerisWrapper.shared
    
    @Published var isSearching = false
    @Published var progress: Double = 0
    
    private init() {}
    
    func search(
        planet: Planet,
        targetDegree: Double,
        startDate: Date,
        endDate: Date,
        tolerance: Double = 0.0001,
        mode: CalculationMode = .geocentric,
        completion: @escaping ([SearchResult]) -> Void
    ) {
        isSearching = true
        progress = 0
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let results = self.performSearch(
                planet: planet,
                targetDegree: targetDegree,
                startDate: startDate,
                endDate: endDate,
                tolerance: tolerance,
                mode: mode
            )
            
            DispatchQueue.main.async {
                self.isSearching = false
                self.progress = 1.0
                completion(results)
            }
        }
    }
    
    private func performSearch(
        planet: Planet,
        targetDegree: Double,
        startDate: Date,
        endDate: Date,
        tolerance: Double,
        mode: CalculationMode
    ) -> [SearchResult] {
        var results: [SearchResult] = []
        
        guard let crossingDates = findCrossings(
            planet: planet,
            targetDegree: targetDegree,
            startDate: startDate,
            endDate: endDate,
            mode: mode
        ) else {
            return results
        }
        
        for crossingDate in crossingDates {
            if let exactDate = refineToSeconds(
                planet: planet,
                targetDegree: targetDegree,
                approximateDate: crossingDate,
                tolerance: tolerance,
                mode: mode
            ) {
                let degree = ephemerisEngine.calculatePositions(
                    planet: planet,
                    date: exactDate,
                    mode: mode
                ) ?? targetDegree
                
                results.append(SearchResult(
                    planet: planet,
                    degree: degree,
                    date: exactDate
                ))
            }
        }
        
        return results.sorted { $0.date < $1.date }
    }
    
    private func findCrossings(
        planet: Planet,
        targetDegree: Double,
        startDate: Date,
        endDate: Date,
        mode: CalculationMode
    ) -> [Date]? {
        var crossings: [Date] = []
        
        let calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        var currentDate = startDate
        var previousDegree: Double?
        var previousDirection: Int = 0
        
        let totalSeconds = Int(endDate.timeIntervalSince(startDate))
        let totalHours = totalSeconds / 3600
        
        guard totalHours > 0 else { return nil }
        
        while currentDate <= endDate {
            let degree = ephemerisEngine.calculatePositions(
                planet: planet,
                date: currentDate,
                mode: mode
            )
            
            guard let currentDegree = degree else {
                currentDate = calendar.date(byAdding: .hour, value: 1, to: currentDate) ?? endDate
                continue
            }
            
            let normalizedDegree = normalizeDegree(currentDegree)
            
            if let prevDegree = previousDegree {
                var diff = normalizedDegree - normalizeDegree(prevDegree)
                
                if diff > 180 {
                    diff -= 360
                } else if diff < -180 {
                    diff += 360
                }
                
                let currentDirection = diff > 0 ? 1 : (diff < 0 ? -1 : previousDirection)
                
                if previousDirection != 0 && currentDirection != previousDirection {
                    crossings.append(currentDate)
                }
                
                previousDirection = currentDirection
            } else {
                previousDirection = 0
            }
            
            previousDegree = normalizedDegree
            
            let hoursScanned = Int(currentDate.timeIntervalSince(startDate)) / 3600
            DispatchQueue.main.async { [weak self] in
                self?.progress = Double(hoursScanned) / Double(totalHours) * 0.5
            }
            
            currentDate = calendar.date(byAdding: .hour, value: 1, to: currentDate) ?? endDate
        }
        
        return crossings.isEmpty ? nil : crossings
    }
    
    private func refineToSeconds(
        planet: Planet,
        targetDegree: Double,
        approximateDate: Date,
        tolerance: Double,
        mode: CalculationMode
    ) -> Date? {
        let calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        var lowDate = calendar.date(byAdding: .hour, value: -1, to: approximateDate) ?? approximateDate
        var highDate = calendar.date(byAdding: .hour, value: 1, to: approximateDate) ?? approximateDate
        
        for _ in 0..<10 {
            let midDate = calendar.date(byAdding: .minute, value: 30, to: lowDate) ?? approximateDate
            
            let lowDegree = ephemerisEngine.calculatePositions(planet: planet, date: lowDate, mode: mode) ?? 0
            let midDegree = ephemerisEngine.calculatePositions(planet: planet, date: midDate, mode: mode) ?? 0
            let highDegree = ephemerisEngine.calculatePositions(planet: planet, date: highDate, mode: mode) ?? 0
            
            let lowDiff = abs(normalizeDegree(lowDegree) - targetDegree)
            let midDiff = abs(normalizeDegree(midDegree) - targetDegree)
            let highDiff = abs(normalizeDegree(highDegree) - targetDegree)
            
            if lowDiff < tolerance {
                return lowDate
            }
            if midDiff < tolerance {
                return midDate
            }
            if highDiff < tolerance {
                return highDate
            }
            
            let target = normalizeDegree(targetDegree)
            let normalizedLow = normalizeDegree(lowDegree)
            let normalizedMid = normalizeDegree(midDegree)
            let normalizedHigh = normalizeDegree(highDegree)
            
            if (normalizedLow < target && normalizedMid > target) ||
               (normalizedLow > target && normalizedMid < target) {
                highDate = midDate
            } else {
                lowDate = midDate
            }
        }
        
        var bestDate = approximateDate
        var bestDiff = Double.infinity
        
        for minuteOffset in 0..<60 {
            let testDate = calendar.date(byAdding: .minute, value: minuteOffset - 30, to: approximateDate) ?? approximateDate
            
            if let degree = ephemerisEngine.calculatePositions(planet: planet, date: testDate, mode: mode) {
                let diff = abs(normalizeDegree(degree) - targetDegree)
                
                if diff < bestDiff {
                    bestDiff = diff
                    bestDate = testDate
                }
            }
        }
        
        if bestDiff < 1.0 {
            return bestDate
        }
        
        return nil
    }
    
    private func normalizeDegree(_ degree: Double) -> Double {
        var result = degree.truncatingRemainder(dividingBy: 360)
        if result < 0 {
            result += 360
        }
        return result
    }
}
