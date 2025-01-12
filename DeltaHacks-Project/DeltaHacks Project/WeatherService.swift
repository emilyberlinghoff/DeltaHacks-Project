import Foundation

// MARK: - WeatherService
struct WeatherService {
    private let apiKey = "6782b2c178b07fe56040c5c5"
    private let baseURL = "https://api.tomorrow.io/v4/timelines"

    // Fetch weather data
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "\(baseURL)?location=\(latitude),\(longitude)&fields=temperature,precipitationType&timesteps=1d&units=metric&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// MARK: - WeatherResponse Models
struct WeatherResponse: Codable {
    let data: WeatherData
}

struct WeatherData: Codable {
    let timelines: [WeatherTimeline]
}

struct WeatherTimeline: Codable {
    let intervals: [WeatherInterval]
}

struct WeatherInterval: Codable {
    let values: WeatherValues
}

struct WeatherValues: Codable {
    let temperature: Double
    let precipitationType: Int
}
