import SwiftUI

struct ContentView: View {
    @State private var arePreferencesSet: Bool = UserDefaults.standard.bool(forKey: "arePreferencesSet")
    @State private var weeklyAvailability: [String: [String]] = UserDefaults.standard.dictionary(forKey: "weeklyAvailability") as? [String: [String]] ?? [:]
    @State private var preferences: [String] = UserDefaults.standard.array(forKey: "preferences") as? [String] ?? []
    @State private var workoutDuration: Int = UserDefaults.standard.integer(forKey: "workoutLength")

    var body: some View {
        NavigationView {
            if arePreferencesSet {
                DashboardView(
                    weeklyAvailability: $weeklyAvailability,
                    preferences: $preferences,
                    workoutDuration: $workoutDuration
                )
            } else {
                PreferencesAndSignupView(onPreferencesSaved: { city, province, availability, workoutsPerWeek, length in
                    UserDefaults.standard.set(city, forKey: "city")
                    UserDefaults.standard.set(province, forKey: "province")
                    UserDefaults.standard.set(availability, forKey: "weeklyAvailability")
                    UserDefaults.standard.set(workoutsPerWeek, forKey: "selectedWorkoutsPerWeek")
                    UserDefaults.standard.set(length, forKey: "workoutLength")

                    arePreferencesSet = true
                    weeklyAvailability = availability
                    workoutDuration = length
                })
            }
        }
        .onAppear {
            if arePreferencesSet {
                loadUserPreferences()
            }
        }
    }

    private func loadUserPreferences() {
        weeklyAvailability = UserDefaults.standard.dictionary(forKey: "weeklyAvailability") as? [String: [String]] ?? [:]
        preferences = UserDefaults.standard.array(forKey: "preferences") as? [String] ?? []
        workoutDuration = UserDefaults.standard.integer(forKey: "workoutLength")
    }
}
