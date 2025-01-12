import Foundation

/// Represents user preferences for workout customization.
struct UserPreferences: Codable {
    var age: Int // User's age
    var occupation: String // User's occupation
    var outdoorWorkoutPreference: Bool // Whether the user prefers outdoor workouts

    /// Converts the `UserPreferences` object to a dictionary for storage or API usage.
    func toDictionary() -> [String: Any] {
        return [
            "age": age,
            "occupation": occupation,
            "outdoorWorkoutPreference": outdoorWorkoutPreference
        ]
    }

    /// Initializes `UserPreferences` from a dictionary.
    init?(dictionary: [String: Any]) {
        guard let age = dictionary["age"] as? Int,
              let occupation = dictionary["occupation"] as? String,
              let outdoorWorkoutPreference = dictionary["outdoorWorkoutPreference"] as? Bool else {
            return nil
        }
        self.age = age
        self.occupation = occupation
        self.outdoorWorkoutPreference = outdoorWorkoutPreference
    }
}

/// Represents an item in the app, such as a workout or a schedule slot.
struct Item: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var date: Date

    /// Formats the item's date into a user-friendly string.
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
