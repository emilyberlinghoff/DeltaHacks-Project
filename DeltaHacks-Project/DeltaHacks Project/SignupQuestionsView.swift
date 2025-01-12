import SwiftUI

struct SignupQuestionsView: View {
    var onPreferencesSaved: () -> Void // Closure to notify when preferences are saved

    @State private var selectedTimesOfDay: [String] = []
    @State private var selectedWorkoutsPerWeek: Int = 3
    @State private var workoutLength: String = ""
    @State private var isCalendarSynced: Bool = false
    @State private var isWeatherAPIConnected: Bool = false

    let timesOfDayOptions = ["Morning", "Afternoon", "Evening"]
    let workoutPerWeekOptions = Array(1...7)

    var body: some View {
        Form {
            // Time of Day Section
            Section(header: Text("Time of Day")) {
                ForEach(timesOfDayOptions, id: \.self) { time in
                    MultipleSelectionRow(title: time, isSelected: selectedTimesOfDay.contains(time)) {
                        if selectedTimesOfDay.contains(time) {
                            selectedTimesOfDay.removeAll { $0 == time }
                        } else {
                            selectedTimesOfDay.append(time)
                        }
                    }
                }
            }

            // Workout Frequency Section
            Section(header: Text("Workouts per Week")) {
                Picker("Select Workouts per Week", selection: $selectedWorkoutsPerWeek) {
                    ForEach(workoutPerWeekOptions, id: \.self) { number in
                        Text("\(number) workouts")
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }

            // Workout Length Section
            Section(header: Text("Workout Length (in minutes)")) {
                TextField("Enter workout length", text: $workoutLength)
                    .keyboardType(.numberPad)
            }

            // Sync Apple Calendar
            Section(header: Text("Sync with Apple Calendar")) {
                Toggle("Allow Read/Write Access", isOn: $isCalendarSynced)
                    .onChange(of: isCalendarSynced) { newValue in
                        if newValue {
                            requestCalendarPermissions()
                        }
                    }
            }

            // Connect Weather API
            Section(header: Text("Connect to Weather API")) {
                Toggle("Enable Weather Integration", isOn: $isWeatherAPIConnected)
                    .onChange(of: isWeatherAPIConnected) { newValue in
                        if newValue {
                            connectToWeatherAPI()
                        }
                    }
            }

            // Save Preferences Button
            Button(action: savePreferences) {
                Text("Save Preferences")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Set Your Preferences")
    }

    private func savePreferences() {
        // Save preferences to UserDefaults
        UserDefaults.standard.set(true, forKey: "arePreferencesSet")
        UserDefaults.standard.set(selectedTimesOfDay, forKey: "selectedTimesOfDay")
        UserDefaults.standard.set(selectedWorkoutsPerWeek, forKey: "selectedWorkoutsPerWeek")
        UserDefaults.standard.set(workoutLength, forKey: "workoutLength")
        UserDefaults.standard.set(isCalendarSynced, forKey: "isCalendarSynced")
        UserDefaults.standard.set(isWeatherAPIConnected, forKey: "isWeatherAPIConnected")

        // Notify parent view
        onPreferencesSaved()
    }

    private func requestCalendarPermissions() {
        print("Requesting Calendar Permissions...")
    }

    private func connectToWeatherAPI() {
        print("Connecting to Weather API...")
    }
}

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct SignupQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SignupQuestionsView(onPreferencesSaved: {})
    }
}
