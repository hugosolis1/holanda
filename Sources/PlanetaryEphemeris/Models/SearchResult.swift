import Foundation

struct SearchResult: Identifiable {
    let id = UUID()
    let planet: Planet
    let degree: Double
    let date: Date
    let isRetrograde: Bool
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var formattedDegree: String {
        String(format: "%.5f", degree)
    }
}
