import Foundation

struct WeatherService {
    /// Fetches hardcoded weather conditions based on location
    func fetchWeatherConditions(for location: String, completion: @escaping (String) -> Void) {
        // Hardcoded behavior for specific locations
        switch location.lowercased() {
        case "london":
            completion("Weather for London, Ontario found.")
        case "sydney":
            completion("Weather for Sydney, Australia found.")
        default:
            completion("Weather for \(location) found.")
        }
    }

    /// Fetches geocoding data for a given address (not used with hardcoding)
    func fetchGeocodingData(for address: String, completion: @escaping (Result<(latitude: Double, longitude: Double), Error>) -> Void) {
        completion(.failure(URLError(.unsupportedURL))) // Placeholder for unused functionality
    }

    /// Fetches weather data for a given latitude and longitude (not used with hardcoding)
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        completion(.failure(URLError(.unsupportedURL))) // Placeholder for unused functionality
    }
}

/// Weather API response model (not used with hardcoding)
struct WeatherResponse: Codable {
    let location: Location
    let forecast: Forecast
}

/// Location details (not used with hardcoding)
struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
}

/// Forecast details (not used with hardcoding)
struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

/// Forecast day details (not used with hardcoding)
struct ForecastDay: Codable {
    let date: String
    let day: Day
}

/// Day details (not used with hardcoding)
struct Day: Codable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: Condition
}

/// Weather condition details (not used with hardcoding)
struct Condition: Codable {
    let text: String
    let icon: String
}
