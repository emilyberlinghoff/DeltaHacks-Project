import SwiftUI

struct ContentView: View {
    @State private var arePreferencesSet: Bool = false

    var body: some View {
        NavigationView {
            if arePreferencesSet {
                DashboardView() // Placeholder for the main dashboard
            } else {
                SignupQuestionsView(onPreferencesSaved: {
                    arePreferencesSet = true
                })
            }
        }
        .onAppear {
            // Check if preferences are already set
            arePreferencesSet = UserDefaults.standard.bool(forKey: "arePreferencesSet")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
