import Foundation
import Combine

class EphemerisViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var selectedTime = Date()
    @Published var calculationMode: CalculationMode = .geocentric
    @Published var planetPositions: [PlanetPosition] = []
    @Published var houseCusps: HouseCusps?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let ephemerisEngine = EphemerisEngine.shared
    private let ascendantCalculator = AscendantCalculator.shared
    
    init() {
        calculate()
    }
    
    var combinedDate: Date {
        get {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
            
            var combined = DateComponents()
            combined.year = dateComponents.year
            combined.month = dateComponents.month
            combined.day = dateComponents.day
            combined.hour = timeComponents.hour
            combined.minute = timeComponents.minute
            combined.second = 0
            combined.timeZone = TimeZone(identifier: "UTC")
            
            return calendar.date(from: combined) ?? Date()
        }
        set {
            let calendar = Calendar.current
            calendar.timeZone = TimeZone(identifier: "UTC")!
            
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: newValue)
            
            var dateComponents = DateComponents()
            dateComponents.year = components.year
            dateComponents.month = components.month
            dateComponents.day = components.day
            selectedDate = calendar.date(from: dateComponents) ?? newValue
            
            var timeComponents = DateComponents()
            timeComponents.hour = components.hour
            timeComponents.minute = components.minute
            selectedTime = calendar.date(from: timeComponents) ?? newValue
        }
    }
    
    func calculate() {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let positions = self.ephemerisEngine.calculateAllPlanetPositions(
                date: self.combinedDate,
                mode: self.calculationMode
            )
            
            let houses = self.ascendantCalculator.calculate(date: self.combinedDate)
            
            DispatchQueue.main.async {
                self.planetPositions = positions
                self.houseCusps = houses
                self.isLoading = false
            }
        }
    }
    
    func updateDate(_ date: Date) {
        selectedDate = date
        calculate()
    }
    
    func updateTime(_ time: Date) {
        selectedTime = time
        calculate()
    }
    
    func updateMode(_ mode: CalculationMode) {
        calculationMode = mode
        calculate()
    }
}
