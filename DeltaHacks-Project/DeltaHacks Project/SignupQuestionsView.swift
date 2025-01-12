import SwiftUI

struct SignupQuestionsView: View {
    var onPreferencesSaved: () -> Void

    @State private var weeklyAvailability: [String: [String]] = [:]
    @State private var selectedWorkoutsPerWeek: Int = 3
    @State private var workoutLength: String = ""

    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let timeSlots = generateHalfHourTimeSlots()

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text("Set Your Weekly Availability")
                    .font(.headline)
                    .padding()

                // Availability Grid
                AvailabilityGrid(
                    daysOfWeek: daysOfWeek,
                    timeSlots: timeSlots,
                    weeklyAvailability: $weeklyAvailability
                )

                // Workout Frequency Section
                Picker("Workouts per Week", selection: $selectedWorkoutsPerWeek) {
                    ForEach(1...7, id: \.self) { number in
                        Text("\(number) workouts")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()

                // Workout Length Section
                TextField("Workout Length (in minutes)", text: $workoutLength)
                    .keyboardType(.numberPad)
                    .padding()

                // Save Preferences Button
                Button(action: savePreferences) {
                    Text("Save Preferences")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
        .navigationTitle("Set Your Preferences")
    }

    private func savePreferences() {
        UserDefaults.standard.set(true, forKey: "arePreferencesSet")
        UserDefaults.standard.set(weeklyAvailability, forKey: "weeklyAvailability")
        UserDefaults.standard.set(selectedWorkoutsPerWeek, forKey: "selectedWorkoutsPerWeek")
        UserDefaults.standard.set(workoutLength, forKey: "workoutLength")
        onPreferencesSaved()
    }

    private static func generateHalfHourTimeSlots() -> [String] {
        var slots: [String] = []
        for hour in 0..<24 {
            let timeFormatter = { (hour: Int, minute: Int) -> String in
                let h = hour % 12 == 0 ? 12 : hour % 12
                let period = hour < 12 ? "AM" : "PM"
                return String(format: "%02d:%02d \(period)", h, minute)
            }
            slots.append(timeFormatter(hour, 0))
            slots.append(timeFormatter(hour, 30))
        }
        return slots
    }
}
