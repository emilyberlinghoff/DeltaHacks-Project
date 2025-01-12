import SwiftUI

struct DashboardView: View {
    @Binding var weeklyAvailability: [String: [String]]
    @Binding var preferences: [String]
    @Binding var workoutDuration: Int
    @State private var city: String = "London" // Default city for testing
    @State private var workoutSchedule: [(date: Date, description: String)] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SharedHeaderSection(title: "Welcome Back!", subtitle: "Here's your personalized workout schedule.")

                SectionCard(title: "Your Workout Schedule") {
                    if workoutSchedule.isEmpty {
                        Text("No schedule available.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    } else {
                        ForEach(workoutSchedule, id: \ .date) { item in
                            ScheduleRow(date: item.date, description: item.description)
                        }
                    }
                }

                Spacer()
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
        .onAppear {
            generateWorkoutSchedule()
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
}

struct ScheduleRow: View {
    let date: Date
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(formatDate(date))
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)

            Text(description)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(
            weeklyAvailability: .constant(["Monday": ["6:00 PM"]]),
            preferences: .constant(["Outdoor"]),
            workoutDuration: .constant(60)
        )
    }
}
