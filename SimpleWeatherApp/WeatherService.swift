//
//  WeatherService.swift
//  SimpleWeatherApp
//
//  Created by David Yoon on 2021/08/03.
//



// let url = URL(string:"api.openweathermap.org/data/2.5/weather?q=London&appid="
// {API key} = 767cd7ad6286d493b227a37032a0bcd6
import CoreLocation
import Foundation

public final class WeatherService: NSObject {
    private let locationManger = CLLocationManager()
    private let API_KEY = "767cd7ad6286d493b227a37032a0bcd6"
    private var completionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        locationManger.delegate = self
        
    }
    
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)) {
        self.completionHandler = completionHandler
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }
    
    // api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D){
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
    }
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}




struct APIResponse: Codable{
    let name: String // City name
    let main: APIMain
    let weather: [APIWeather]
}


struct APIMain: Codable {
    let temp: Double
}


struct APIWeather: Codable {
    let description: String
    let iconName: String
    
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main" //"main" is json key json dat main will match with iconName var
    }
}
