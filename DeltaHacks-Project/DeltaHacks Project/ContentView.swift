import SwiftUI

struct ContentView: View {
    @State private var arePreferencesSet: Bool = false

    var body: some View {
        NavigationView {
            if arePreferencesSet {
                // Main screen (e.g., Dashboard)
                DashboardView()
            } else {
                // Show SignupQuestionsView for setting preferences
                SignupQuestionsView(onPreferencesSaved: {
                    // Update state when preferences are saved
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
