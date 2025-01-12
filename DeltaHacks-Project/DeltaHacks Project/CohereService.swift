import Foundation

class CohereService {
    let apiKey = "eFRCtDLuwZtQos7AF4eMEICIaKj9pzwoHKN7E6ne" // Replace with your actual Cohere API key
    let apiUrl = "https://api.cohere.ai/generate"

    func fetchWorkoutRecommendation(
        weeklyAvailability: [String: [String]],
        workoutsPerWeek: Int,
        workoutLength: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let url = URL(string: apiUrl) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let availabilityDescription = weeklyAvailability.map { day, times in
            "\(day): \(times.joined(separator: ", "))"
        }.joined(separator: "\n")

        let prompt = """
        Based on the following weekly availability:
        \(availabilityDescription),
        and a preference for \(workoutsPerWeek) workouts per week, each lasting \(workoutLength) minutes, suggest the best schedule for workouts.
        """

        let payload: [String: Any] = [
            "model": "command-xlarge-20221108",
            "prompt": prompt,
            "max_tokens": 300,
            "temperature": 0.7,
            "k": 0,
            "p": 0.75,
            "frequency_penalty": 0,
            "presence_penalty": 0,
            "stop_sequences": []
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let generations = json["generations"] as? [[String: Any]],
                   let text = generations.first?["text"] as? String {
                    completion(.success(text))
                } else {
                    completion(.failure(URLError(.badServerResponse)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
