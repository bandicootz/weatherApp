import Foundation

struct WeatherClient {
    func  fetchWeather(location: Location?) async throws -> Weather {
        let (data, response) = try await URLSession.shared.data(from: APIEndpoints.endpointURL(for: .weatherByLatLon(location?.lat ?? 0, location?.lon ?? 0)))

        guard let httpsResponse = response as? HTTPURLResponse,
              httpsResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return weatherResponse.main
    }
}
