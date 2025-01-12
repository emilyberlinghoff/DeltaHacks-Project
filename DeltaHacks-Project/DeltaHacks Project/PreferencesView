import SwiftUI

struct PreferencesView: View {
    @State private var isWeatherAPIConnected: Bool = false
    @State private var weatherMessage: String = "Weather information not available."
    private let weatherService = WeatherService()

    var body: some View {
        Form {
            Section(header: Text("Connect to Weather API")) {
                Toggle("Connect Weather API", isOn: $isWeatherAPIConnected)
                    .onChange(of: isWeatherAPIConnected) { newValue in
                        if newValue {
                            fetchWeatherAndRecommend()
                        }
                    }
            }

            Section(header: Text("Weather Recommendation")) {
                Text(weatherMessage)
            }

            Button(action: fetchWeatherAndRecommend) {
                Text("Get Weather Recommendation")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Set Your Preferences")
    }

    // Fetch weather data and determine indoor or outdoor session
    private func fetchWeatherAndRecommend() {
        let latitude = 40.7128  // Example: Replace with actual user location
        let longitude = -74.0060

        weatherService.fetchWeatherData(latitude: latitude, longitude: longitude) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let weatherInterval = response.data.timelines.first?.intervals.first {
                        let temperature = weatherInterval.values.temperature
                        let precipitationType = weatherInterval.values.precipitationType

                        // Determine recommendation
                        if temperature < 10 || precipitationType != 0 {
                            weatherMessage = "It's cold or rainy. Schedule an indoor gym session."
                        } else {
                            weatherMessage = "It's warm and sunny. Schedule an outdoor gym session."
                        }
                    } else {
                        weatherMessage = "Weather data unavailable."
                    }
                case .failure(let error):
                    weatherMessage = "Failed to fetch weather data: \(error.localizedDescription)"
                }
            }
        }
    }
}
