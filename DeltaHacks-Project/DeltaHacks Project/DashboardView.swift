import SwiftUI

struct DashboardView: View {
    @Binding var weeklyAvailability: [String: [String]]
    @Binding var preferences: [String]
    @Binding var workoutDuration: Int
    @State private var city: String = "London" // Default city for testing
    @State private var workoutSchedule: [(date: Date, description: String)] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Workout Schedule")
                            .font(.headline)

                        if workoutSchedule.isEmpty {
                            Text("No schedule available.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(workoutSchedule, id: \.date) { item in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(formatDate(item.date))
                                        .font(.subheadline)
                                        .bold()
                                    Text(item.description)
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                .padding(.bottom, 5)
                            }
                        }
                    }
                    .padding()

                    Spacer()
                }
                .padding()
                .onAppear {
                    generateWorkoutSchedule()
                }
            }
            .navigationTitle("Dashboard")
        }
    }

    private func generateWorkoutSchedule() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE h:mm a"
        var schedule: [(date: Date, description: String)] = []

        for (day, times) in weeklyAvailability {
            guard let timeString = times.first, let dayDate = getNextDate(for: day) else { continue }

            if let startTime = formatter.date(from: "\(day) \(timeString)") {
                let endTime = Calendar.current.date(byAdding: .minute, value: workoutDuration, to: startTime)
                let weatherCondition = determineWeatherCondition(for: day)
                if let endTime = endTime {
                    let description = "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime)) (\(weatherCondition))"
                    schedule.append((date: dayDate, description: description))
                }
            }
        }

        workoutSchedule = schedule.sorted { $0.date < $1.date }
    }

    private func determineWeatherCondition(for day: String) -> String {
        if city.lowercased() == "london" {
            return "Indoor"
        } else if city.lowercased() == "sydney" && day == "Monday" {
            return "Outdoor"
        }
        return "Indoor"
    }

    private func getNextDate(for day: String) -> Date? {
        let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"

        guard let weekdayIndex = weekdays.firstIndex(of: day) else { return nil }

        let today = Date()
        let calendar = Calendar.current
        let todayWeekdayIndex = calendar.component(.weekday, from: today) - 1

        let dayDifference = (weekdayIndex >= todayWeekdayIndex) ? weekdayIndex - todayWeekdayIndex : weekdayIndex - todayWeekdayIndex + 7
        return calendar.date(byAdding: .day, value: dayDifference, to: today)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: date)
    }
}
