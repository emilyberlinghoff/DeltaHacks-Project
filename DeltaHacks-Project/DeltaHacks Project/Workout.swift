import SwiftUI
import Foundation

struct Workout: Identifiable {
    let id = UUID() // Unique identifier for each workout
    let name: String // Name of the workout
    let duration: Int // Duration of the workout in minutes
    let intensity: String // Intensity level (e.g., "Low", "Medium", "High")
}

struct WorkoutScheduleView: View {
    @Binding var weeklyAvailability: [String: [String]]
    @Binding var preferences: [String]
    @Binding var workoutDuration: Int

    @State private var workouts: [Workout] = []
    @State private var isLoading: Bool = false
    @State private var updatedSchedule: [(date: Date, description: String)] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Weekly Workout Schedule")
                    .font(.headline)
                    .padding()

                if isLoading {
                    ProgressView("Generating schedule...")
                } else if updatedSchedule.isEmpty {
                    Text("No schedule available. Please check your weekly availability.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                } else {
                    List(updatedSchedule, id: \.date) { item in
                        VStack(alignment: .leading) {
                            Text(item.date, style: .date) // Full date
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("Workout Schedule")
            .onAppear {
                generateWorkoutSchedule()
            }
        }
    }

    private func generateWorkoutSchedule() {
        isLoading = true
        defer { isLoading = false }

        guard !weeklyAvailability.isEmpty else {
            updatedSchedule = []
            return
        }

        var schedule: [(date: Date, description: String)] = []

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE h:mm a" // Day and time format

        for (day, times) in weeklyAvailability {
            guard let timeString = times.first, !times.isEmpty else { continue }

            let startTime = formatter.date(from: "\(day) \(timeString)")
            let endTime = Calendar.current.date(byAdding: .minute, value: workoutDuration, to: startTime ?? Date())

            if let startTime = startTime, let endTime = endTime {
                let weatherCondition = preferences.contains("Outdoor") && day == "Monday" ? "Outdoor" : "Indoor"
                let description = "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime)) (\(weatherCondition))"
                schedule.append((date: getNextDate(for: day) ?? Date(), description: description))
            }
        }

        updatedSchedule = schedule.sorted { $0.date < $1.date }
    }

    private func getNextDate(for day: String) -> Date? {
        let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

        guard let weekdayIndex = weekdays.firstIndex(of: day) else { return nil }

        let today = Date()
        let calendar = Calendar.current
        let todayWeekdayIndex = calendar.component(.weekday, from: today) - 1

        let dayDifference = (weekdayIndex >= todayWeekdayIndex) ? weekdayIndex - todayWeekdayIndex : weekdayIndex - todayWeekdayIndex + 7
        return calendar.date(byAdding: .day, value: dayDifference, to: today)
    }
}
