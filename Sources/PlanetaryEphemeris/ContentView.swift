import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            EphemeridesView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Ephemerides")
                }
            
            DegreeSearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Degree Search")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
