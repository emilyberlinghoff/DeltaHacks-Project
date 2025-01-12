import SwiftUI

struct PreferencesAndSignupView: View {
    @State private var city: String = ""
    @State private var province: String = ""
    @State private var weeklyAvailability: [String: [String]] = [
        "Monday": [],
        "Tuesday": [],
        "Wednesday": [],
        "Thursday": [],
        "Friday": [],
        "Saturday": [],
        "Sunday": []
    ]
    @State private var selectedWorkoutsPerWeek: Int = 3
    @State private var workoutLength: String = ""
    @State private var workoutPreferences: String = ""
    @State private var scheduledDays: [String] = []

    let onPreferencesSaved: (String, String, [String: [String]], Int, Int, String) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SharedHeaderSection(title: "Set Your Preferences", subtitle: "Tailor your workout plan to your needs.")

                SectionCard(title: "Your Location") {
                    InputField(placeholder: "City", text: $city)
                        .foregroundColor(.black)
                    InputField(placeholder: "Province", text: $province)
                        .foregroundColor(.black)
                }

                SectionCard(title: "Your Weekly Availability") {
                    WeeklyAvailabilityGrid(
                        daysOfWeek: Constants.daysOfWeek,
                        timeSlots: WeeklyAvailabilityGrid.generateHalfHourTimeSlots(),
                        weeklyAvailability: $weeklyAvailability
                    )
                }

                SectionCard(title: "Workouts per Week") {
                    Picker("Workouts per Week", selection: $selectedWorkoutsPerWeek) {
                        ForEach(1...7, id: \ .self) { count in
                            Text("\(count) workouts")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                SectionCard(title: "Workout Length (in minutes)") {
                    InputField(placeholder: "Enter workout length", text: $workoutLength, keyboardType: .numberPad)
                }

                SectionCard(title: "Describe Your Workout Preferences") {
                    TextEditor(text: $workoutPreferences)
                        .frame(height: 100)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                        )
                }

                SectionCard(title: "Scheduled Workouts") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(scheduledDays, id: \ .self) { day in
                            VStack(alignment: .leading) {
                                Text(day)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                if let workouts = weeklyAvailability[day], !workouts.isEmpty {
                                    ForEach(workouts, id: \ .self) { workout in
                                        Text("• \(workout)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                } else {
                                    Text("No workouts scheduled.")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                SaveButton(title: "Save Preferences") {
                    savePreferences()
                }
            }
            .padding()
            .background(LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .padding()
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            scheduleWorkouts()
        }
    }

    private func savePreferences() {
        let length = Int(workoutLength) ?? Constants.defaultWorkoutLength
        scheduleWorkouts()
        onPreferencesSaved(city, province, weeklyAvailability, selectedWorkoutsPerWeek, length, workoutPreferences)
    }

    private func scheduleWorkouts() {
        // Hardcode scheduling for Monday, Wednesday, and Friday
        scheduledDays = ["Monday", "Wednesday", "Friday"].filter { !weeklyAvailability[$0, default: []].isEmpty }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SharedHeaderSection: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.bottom, 16)
    }
}

struct SectionCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 8)
                .foregroundColor(Color.white)

            content
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
        }
        .padding()
        .background(Color.blue.opacity(0.6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

struct InputField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .keyboardType(keyboardType)
    }
}

struct SaveButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
    }
}

// MARK: - Constants

struct Constants {
    static let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    static let defaultWorkoutLength = 45
}

// MARK: - Availability Grid

struct WeeklyAvailabilityGrid: View {
    let daysOfWeek: [String]
    let timeSlots: [String]
    @Binding var weeklyAvailability: [String: [String]]

    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Time")
                        .frame(width: 60, height: 40)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(5)
                        .font(.caption)
                        .bold()

                    ForEach(daysOfWeek, id: \ .self) { day in
                        Text(day)
                            .frame(width: 80, height: 40)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(5)
                            .font(.caption)
                            .bold()
                    }
                }

                ForEach(timeSlots, id: \ .self) { time in
                    HStack {
                        Text(time)
                            .frame(width: 60, height: 40)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(5)
                            .font(.caption)

                        ForEach(daysOfWeek, id: \ .self) { day in
                            Button(action: {
                                toggleAvailability(for: day, at: time)
                            }) {
                                Rectangle()
                                    .fill(
                                        weeklyAvailability[day]?.contains(time) == true ? Color.purple : Color.white
                                    )
                                    .frame(width: 80, height: 40)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                        }
                    }
                }
            }
        }
    }

    private func toggleAvailability(for day: String, at time: String) {
        if weeklyAvailability[day]?.contains(time) == true {
            weeklyAvailability[day]?.removeAll { $0 == time }
        } else {
            if weeklyAvailability[day] == nil {
                weeklyAvailability[day] = []
            }
            weeklyAvailability[day]?.append(time)
        }
    }

    static func generateHalfHourTimeSlots() -> [String] {
        var slots: [String] = []
        for hour in 0..<24 {
            let formatter = { (hour: Int, minute: Int) -> String in
                let h = hour % 12 == 0 ? 12 : hour % 12
                let period = hour < 12 ? "AM" : "PM"
                return String(format: "%02d:%02d %@", h, minute, period)
            }
            slots.append(formatter(hour, 0))
            slots.append(formatter(hour, 30))
        }
        return slots
    }
}

struct MainContentView: View {
    var body: some View {
        PreferencesAndSignupView { city, province, availability, workoutsPerWeek, length, preferences in
            // Handle the saved preferences here
            print("City: \(city)")
            print("Province: \(province)")
            print("Availability: \(availability)")
            print("Workouts Per Week: \(workoutsPerWeek)")
            print("Workout Length: \(length)")
            print("Workout Preferences: \(preferences)")
        }
    }
}
