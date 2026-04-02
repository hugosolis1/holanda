import SwiftUI

struct EphemeridesView: View {
    @StateObject private var viewModel = EphemerisViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                inputSection
                calculateButton
                
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else {
                    resultsList
                }
                
                Spacer()
            }
            .navigationTitle("Ephemerides")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var inputSection: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Date (UTC)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .onChange(of: viewModel.selectedDate) { newValue in
                        viewModel.updateDate(newValue)
                    }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Time (UTC)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                DatePicker("Select Time", selection: $viewModel.selectedTime, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.compact)
                    .onChange(of: viewModel.selectedTime) { newValue in
                        viewModel.updateTime(newValue)
                    }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Calculation Mode")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("Mode", selection: $viewModel.calculationMode) {
                    ForEach(CalculationMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.calculationMode) { newValue in
                    viewModel.updateMode(newValue)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .padding()
    }
    
    private var calculateButton: some View {
        Button(action: viewModel.calculate) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                Text("Calculate")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
    
    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Calculating...")
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private func errorView(_ message: String) -> some View {
        Text(message)
            .foregroundColor(.red)
            .padding()
    }
    
    private var resultsList: some View {
        List {
            Section(header: Text("Planets")) {
                ForEach(viewModel.planetPositions) { position in
                    PlanetRowView(position: position)
                }
            }
            
            if let houses = viewModel.houseCusps {
                Section(header: Text("House Cusps")) {
                    HouseCuspRow(title: "Ascendant (ASC)", value: houses.formattedAscendant)
                    HouseCuspRow(title: "Medium Coeli (MC)", value: houses.formattedMC)
                    HouseCuspRow(title: "Descendant (DESC)", value: houses.formattedDescendant)
                    HouseCuspRow(title: "Imum Coeli (IC)", value: houses.formattedIC)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct PlanetRowView: View {
    let position: PlanetPosition
    
    var body: some View {
        HStack {
            Text(position.planet.name)
                .font(.body)
            Spacer()
            Text(position.formattedLongitude)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.secondary)
            if position.isRetrograde {
                Text("R")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 4)
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(4)
            }
        }
    }
}

struct HouseCuspRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
            Spacer()
            Text(value)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.secondary)
        }
    }
}

struct EphemeridesView_Previews: PreviewProvider {
    static var previews: some View {
        EphemeridesView()
    }
}
