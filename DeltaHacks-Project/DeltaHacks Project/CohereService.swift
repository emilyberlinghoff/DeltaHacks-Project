import SwiftUI

struct DashboardView: View {
    @Binding var weeklyAvailability: [String: [String]]
    @Binding var preferences: [String]
    @Binding var workoutDuration: Int
    @State private var city: String = "" // City provided by user
    @State private var workoutSchedule: [(day: String, description: String)] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SharedHeaderSection(title: "Your Workout Dashboard", subtitle: "Your personalized workout schedule and recommendations.")

                SectionCard(title: "Your Workout Schedule") {
                    if workoutSchedule.isEmpty {
                        Text("No schedule available. Please ensure your preferences are saved.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    } else {
                        ForEach(workoutSchedule.sorted(by: { sortDays($0.day, $1.day) }), id: \ .day) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.day)
                                    .font(.headline)
                                    .foregroundColor(.blue)

                                Text(item.description)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
        let hardcodedWorkouts = [
            "Monday": "Jogging (Outdoor)",
            "Wednesday": "Yoga (Indoor)",
            "Friday": "Treadmill Running (Indoor)"
        ]

        var schedule: [(day: String, description: String)] = []

        for (day, activity) in hardcodedWorkouts {
            if let availableTimes = weeklyAvailability[day], !availableTimes.isEmpty {
                let startTime = availableTimes.first ?? "Unknown time"
                let endTime = calculateEndTime(from: startTime)
                let description = "\(startTime) - \(endTime): \(activity)"
                schedule.append((day: day, description: description))
            } else {
                schedule.append((day: day, description: "No availability provided for \(activity)."))
            }
        }

        workoutSchedule = schedule
    }

    private func calculateEndTime(from startTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        guard let date = formatter.date(from: startTime) else { return "Unknown end time" }
        let endDate = Calendar.current.date(byAdding: .minute, value: workoutDuration, to: date) ?? date
        return formatter.string(from: endDate)
    }

    private func sortDays(_ day1: String, _ day2: String) -> Bool {
        let daysOrder = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        return (daysOrder.firstIndex(of: day1) ?? 0) < (daysOrder.firstIndex(of: day2) ?? 0)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(
            weeklyAvailability: .constant([
                "Monday": ["6:00 AM"],
                "Wednesday": ["7:00 AM"],
                "Friday": ["8:00 AM"]
            ]),
            preferences: .constant(["Yoga", "HIIT"]),
            workoutDuration: .constant(45)
        )
    }
}
