import SwiftUI

struct ContentView: View {

    @State private var city: String = ""
    @State private var currentCity: String = ""
    @State private var isFetchingWeather: Bool = false
    
    let geocodingClient: GeocodingClient = GeocodingClient()
    let weatherClient: WeatherClient = WeatherClient()

    @State private var weather: Weather?

    private func fetchWeather() async {
        do {
            guard let location = try await geocodingClient.coordinateByCity(city) else { return }
            weather = try await weatherClient.fetchWeather(location: location)
        } catch {
            print(error)
        }
    }

    var body: some View {
        VStack {
            TextField("City", text: $city)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    isFetchingWeather = true
                }.task(id: isFetchingWeather) {
                    if isFetchingWeather {
                        await fetchWeather()
                        isFetchingWeather = false
                        currentCity = city
                        city = ""
                    }
                }
            Spacer()
            if let weather {
                Text("\(currentCity)")
                    .font(.title3)
                    .foregroundStyle(.brown)
                Text("\(Int((weather.temp - 273.15).rounded(.toNearestOrAwayFromZero)))")
                    .font(.largeTitle)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
