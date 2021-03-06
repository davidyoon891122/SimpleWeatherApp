//
//  WeatherViewModel.swift
//  SimpleWeatherApp
//
//  Created by David Yoon on 2021/08/03.
//

import Foundation


private let defaultIcon = "π€·ββοΈ"

private let iconMap = [
    "Drizzle":"π§",
    "Thunderstorm":"β",
    "Rain":"π§",
    "Snow":"βοΈ",
    "Clear":"βοΈ",
    "Clouds":"βοΈ",
]


public class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "City Name"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "--"
    @Published var weatherIcon: String = defaultIcon
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    public func refresh() {
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.sync {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)ΒΊ"
                self.weatherDescription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
            }
    }
    
}
}

