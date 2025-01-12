import SwiftUI

struct AvailabilityGrid: View {
    let daysOfWeek: [String]
    let timeSlots: [String]
    @Binding var weeklyAvailability: [String: [String]]

    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .leading) {
                // Header Row
                HStack {
                    Text("Time")
                        .frame(width: 60, height: 40)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(5)
                        .font(.caption)
                        .bold()

                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .frame(width: 80, height: 40)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(5)
                            .font(.caption)
                            .bold()
                    }
                }

                // Time Slots with Days
                ForEach(timeSlots, id: \.self) { time in
                    HStack {
                        // Time Column
                        Text(time)
                            .frame(width: 60, height: 40)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(5)
                            .font(.caption)

                        // Day Columns
                        ForEach(daysOfWeek, id: \.self) { day in
                            Button(action: {
                                toggleAvailability(for: day, at: time)
                            }) {
                                Rectangle()
                                    .fill(
                                        weeklyAvailability[day]?.contains(time) == true ? Color.blue : Color.gray.opacity(0.2)
                                    )
                                    .frame(width: 80, height: 40)
                                    .cornerRadius(5)
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
                return String(format: "%02d:%02d \(period)", h, minute)
            }
            slots.append(formatter(hour, 0))
            slots.append(formatter(hour, 30))
        }
        return slots
    }
}
