import SwiftUI

struct DegreeSearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                inputSection
                searchButton
                
                if viewModel.isSearching {
                    searchingView
                } else {
                    resultsList
                }
                
                Spacer()
            }
            .navigationTitle("Degree Search")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var inputSection: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Planet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("Planet", selection: $viewModel.selectedPlanet) {
                    ForEach(Planet.allCases) { planet in
                        Text(planet.name).tag(planet)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Target Degree (0-360)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Degree", text: $viewModel.targetDegree)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Start Date (UTC)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: [.date])
                    .datePickerStyle(.compact)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("End Date (UTC)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: [.date])
                    .datePickerStyle(.compact)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tolerance")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Tolerance", text: $viewModel.tolerance)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                Text("Default: 0.0001")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .padding()
    }
    
    private var searchButton: some View {
        Button(action: viewModel.search) {
            HStack {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding(.horizontal)
        .disabled(viewModel.isSearching)
    }
    
    private var searchingView: some View {
        VStack(spacing: 12) {
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.linear)
            Text("Searching... \(Int(viewModel.progress * 100))%")
                .foregroundColor(.secondary)
            Text("This may take a while for large date ranges")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private var resultsList: some View {
        Group {
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.searchResults.isEmpty {
                Text("Enter a degree and date range, then tap Search")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List {
                    ForEach(viewModel.searchResults) { result in
                        SearchResultRow(result: result)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
}

struct SearchResultRow: View {
    let result: SearchResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(result.planet.name)
                    .font(.headline)
                Spacer()
                Text(result.formattedDegree)
                    .font(.system(.body, design: .monospaced))
            }
            
            HStack {
                Text(result.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(result.formattedTime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct DegreeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DegreeSearchView()
    }
}
