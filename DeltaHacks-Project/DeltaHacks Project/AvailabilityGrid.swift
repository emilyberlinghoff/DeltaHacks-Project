import SwiftUI

// This view represents a grid for selecting weekly availability based on time slots and days of the week.
struct AvailabilityGrid: View {
    // Days of the week to display as columns.
    let daysOfWeek: [String]
    // Time slots (e.g., half-hour increments) to display as rows.
    let timeSlots: [String]
    // Binding to the dictionary that holds the user's weekly availability.
    @Binding var weeklyAvailability: [String: [String]]

    var body: some View {
        ScrollView(.horizontal) { // Allows horizontal scrolling for days of the week.
            VStack(alignment: .leading) {
                // Header row displaying days of the week.
                HStack {
                    // "Time" label as the first column header.
                    Text("Time")
                        .frame(width: 60, height: 40)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(5)
                        .font(.caption)
                        .bold()

                    // Headers for each day of the week.
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .frame(width: 80, height: 40)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(5)
                            .font(.caption)
                            .bold()
                    }
                }

                // Rows displaying time slots with availability toggles for each day.
                ForEach(timeSlots, id: \.self) { time in
                    HStack {
                        // Time label in the first column for the current row.
                        Text(time)
                            .frame(width: 60, height: 40)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(5)
                            .font(.caption)

                        // Buttons for each day of the week corresponding to the current time slot.
                        ForEach(daysOfWeek, id: \.self) { day in
                            Button(action: {
                                // Toggle the availability for this day and time.
                                toggleAvailability(for: day, at: time)
                            }) {
                                Rectangle()
                                    .fill(
                                        // Highlight the button if this time slot is available for the given day.
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

    // Function to toggle availability for a given day and time.
    private func toggleAvailability(for day: String, at time: String) {
        // If the time slot is already available for the given day, remove it.
        if weeklyAvailability[day]?.contains(time) == true {
            weeklyAvailability[day]?.removeAll { $0 == time }
        } else {
            // Otherwise, add it to the availability for the given day.
            if weeklyAvailability[day] == nil {
                weeklyAvailability[day] = [] // Initialize the array if it doesn't exist.
            }
            weeklyAvailability[day]?.append(time)
        }
    }

    // Static helper function to generate half-hour time slots for a 24-hour day.
    static func generateHalfHourTimeSlots() -> [String] {
        var slots: [String] = []
        for hour in 0..<24 { // Loop through each hour of the day.
            let formatter = { (hour: Int, minute: Int) -> String in
                let h = hour % 12 == 0 ? 12 : hour % 12 // Convert 24-hour time to 12-hour format.
                let period = hour < 12 ? "AM" : "PM" // Determine AM or PM.
                return String(format: "%02d:%02d \(period)", h, minute) // Format time as HH:mm AM/PM.
            }
            slots.append(formatter(hour, 0)) // Add the hour with ":00".
            slots.append(formatter(hour, 30)) // Add the hour with ":30".
        }
        return slots
    }
}
