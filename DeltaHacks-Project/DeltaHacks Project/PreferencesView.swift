import SwiftUI

struct PreferencesAndSignupView: View {
    @State private var city: String = ""
    @State private var province: String = ""
    @State private var weeklyAvailability: [String: [String]] = [:]
    @State private var selectedWorkoutsPerWeek: Int = 3
    @State private var workoutLength: String = ""

    let onPreferencesSaved: (String, String, [String: [String]], Int, Int) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Set Your Location")
                    .font(.headline)
                TextField("City", text: $city)
                TextField("Province", text: $province)

                Text("Set Your Weekly Availability")
                AvailabilityGrid(
                    daysOfWeek: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
                    timeSlots: AvailabilityGrid.generateHalfHourTimeSlots(),
                    weeklyAvailability: $weeklyAvailability
                )

                Picker("Workouts per Week", selection: $selectedWorkoutsPerWeek) {
                    ForEach(1...7, id: \.self) { Text("\($0) workouts") }
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("Workout Length (in minutes)", text: $workoutLength)
                    .keyboardType(.numberPad)

                Button("Save Preferences") {
                    let length = Int(workoutLength) ?? 45
                    onPreferencesSaved(city, province, weeklyAvailability, selectedWorkoutsPerWeek, length)
                }
            }
            .padding()
        }
    }
}
