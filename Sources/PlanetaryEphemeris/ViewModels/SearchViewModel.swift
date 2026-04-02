import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var selectedPlanet: Planet = .sun
    @Published var targetDegree: String = ""
    @Published var startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    @Published var endDate = Date()
    @Published var tolerance: String = "0.0001"
    @Published var searchResults: [SearchResult] = []
    @Published var isSearching = false
    @Published var progress: Double = 0
    @Published var errorMessage: String?
    
    private let searchEngine = DegreeSearchEngine.shared
    
    init() {
        let calendar = Calendar.current
        endDate = Date()
        startDate = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    }
    
    func search() {
        guard let degree = Double(targetDegree), degree >= 0, degree <= 360 else {
            errorMessage = "Please enter a valid degree (0-360)"
            return
        }
        
        guard let tol = Double(tolerance), tol > 0 else {
            errorMessage = "Please enter a valid tolerance"
            return
        }
        
        guard startDate < endDate else {
            errorMessage = "Start date must be before end date"
            return
        }
        
        errorMessage = nil
        isSearching = true
        progress = 0
        
        searchEngine.isSearching = true
        searchEngine.progress = 0
        
        searchEngine.search(
            planet: selectedPlanet,
            targetDegree: degree,
            startDate: startDate,
            endDate: endDate,
            tolerance: tol,
            mode: .geocentric
        ) { [weak self] results in
            guard let self = self else { return }
            
            self.searchResults = results
            self.isSearching = false
            self.progress = 1.0
            
            if results.isEmpty {
                self.errorMessage = "No crossing found in the specified date range"
            }
        }
    }
    
    func cancelSearch() {
        isSearching = false
        progress = 0
    }
}
