import Foundation

enum NetworkError: Error {
    case invalidResponse
}

struct GeocodingClient {
    func coordinateByCity(_ city: String) async throws -> Location? {
        let (data, response) = try await URLSession.shared.data(from: APIEndpoints.endpointURL(for: .coordinatesByLocationName(city)))

        guard let httpsResponse = response as? HTTPURLResponse,
              httpsResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        let locations = try JSONDecoder().decode([Location].self, from: data)
        return locations.first
    }
}
