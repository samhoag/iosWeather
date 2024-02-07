//
//  WeatherViewModel.swift
//  NPS Data Explorer
//
//  Created by Sam Hoag on 2/3/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var forecastItems: [WeatherPeriod] = []
    @Published var forecastInformation: [WeatherPoint] = []
    @Published var forecastDetailedInformation: [WeatherDetailedForecast] = []
    @Published var locationInformation: [GeocodeLocation] = []
    @Published var isLoading: Bool = true
    @Published var latitude: String = "42.7978"
    @Published var longitude: String = "-83.7049"
    
    init(){
        fetchLatLong(query: "Lake Fenton")
    }
    
    func formatData() {
        // Loop through forecastItems and set the name property to "Hello, world!"
        for index in forecastItems.indices {
            forecastItems[index].name = Utilities.capitalizeFirstCharOnly(rawText: forecastItems[index].name)
        }
    }
    
    func fetchDetailedForecast() {
        let gridUrl = self.forecastInformation[0].properties.forecastGridData
        
        // Create a URLSession
        let gridSession = URLSession.shared
        
        // Create a data task to fetch the data
        let gridTask = gridSession.dataTask(with: gridUrl) { [weak self] (data, response, error) in
            guard let self = self else { return }
            // Check for errors
            if let error = error {
                print("Error fetching data: \(error)")
                self.isLoading = false
                return
            }
            // Ensure there is data
            guard let data = data else {
                print("No data returned")
                self.isLoading = false
                return
            }
            // Attempt to decode the data
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let weatherDetailedData = try decoder.decode(WeatherDetailedForecast.self, from: data)
                // Update forecastItems on the main thread
                DispatchQueue.main.async {
                    self.forecastDetailedInformation = [weatherDetailedData]
                    self.isLoading = false
                    self.formatData()
                }
            } catch {
                print("Error decoding DF JSON: \(error)")
                self.isLoading = false
            }
        }
        gridTask.resume()
    }
    
    func fetchForecast() {
        // URL of the endpoint
        //guard
        let url = self.forecastInformation[0].properties.forecast //else {
        //   print("Invalid URL")
        //   return
        //}
        //guard let url = URL(string: "https://api.weather.gov/gridpoints/SGX/57,14/forecast") else {
        //    print("Invalid URL")
        //    return
        //}
        
        // Create a URLSession
        let session = URLSession.shared
        
        // Create a data task to fetch the data
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            // Check for errors
            if let error = error {
                print("Error fetching data: \(error)")
                self.isLoading = false
                return
            }
            // Ensure there is data
            guard let data = data else {
                print("No data returned")
                self.isLoading = false
                return
            }
            // Attempt to decode the data
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let weatherData = try decoder.decode(WeatherItem.self, from: data)
                // Update forecastItems on the main thread
                DispatchQueue.main.async {
                    self.forecastItems = weatherData.properties.periods
                    self.formatData()
                    self.fetchDetailedForecast()
                }
            } catch {
                print("Error decoding F JSON: \(error)")
                self.isLoading = false
            }
        }
        
        
        
        // Start the data task
        
        task.resume()
        
        
        // Start the data task
        
        
    }
    
    func fetchData() {
        // Build WeatherPoint object here
        guard let wpUrl = URL(string: Utilities.getWeatherAPIEndPoint(lat: self.latitude, long: self.longitude)) else {
            print("Invalid URL")
            return
        }
        
        // Create a URLSession
        let wpSession = URLSession.shared
        // Create a data task to fetch the data
        let wpTask = wpSession.dataTask(with: wpUrl) { [weak self] (data, response, error) in
            
            guard let self = self else {
                
                return }
            // Check for errors
            if let error = error {
                print("Error fetching data: \(error)")
                self.isLoading = false
                return
            }
            // Ensure there is data
            guard let data = data else {
                print("No data returned")
                self.isLoading = false
                return
            }
            // Attempt to decode the data
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let weatherPointData = try decoder.decode(WeatherPoint.self, from: data)
                // Update forecastItems on the main thread
                DispatchQueue.main.async {
                    self.forecastInformation = [weatherPointData]
                    self.fetchForecast()
                }
            } catch {
                print("Error decoding WP JSON: \(error)")
                self.isLoading = false
            }
        }
        wpTask.resume()
        
    }
    
    func fetchLatLong(query: String) {
        // call a format url utility
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            if let configDict = NSDictionary(contentsOfFile: path) {
                if let apiKey = configDict["GeocodeKey"] as? String {
                    let endpoint = "https://geocode.maps.co/search?q=\(query)&api_key=\(apiKey)"
                    
                    
                    // for now, just use this url:
                    
                    // make the API request, build the models
                    self.isLoading = true
                    
                    guard let url = URL(string: endpoint) else {
                        print("Invalid URL")
                        return
                    }
                    
                    // Create a URLSession
                    let session = URLSession.shared
                    // Create a data task to fetch the data
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        
                        
                        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                            
                            guard let self = self else {
                                
                                return }
                            // Check for errors
                            if let error = error {
                                print("Error fetching data: \(error)")
                                self.isLoading = false
                                return
                            }
                            // Ensure there is data
                            guard let data = data else {
                                print("No data returned")
                                self.isLoading = false
                                return
                            }
                            // Attempt to decode the data
                            do {
                                //let decoder = JSONDecoder()
                                //decoder.dateDecodingStrategy = .iso8601
                                //let locationData = try decoder.decode(Location.self, from: data)
                                print(data)
                                let locationData = try JSONDecoder().decode([GeocodeLocation].self, from: data)
                                // Update forecastItems on the main thread
                                DispatchQueue.main.async {
                                    self.locationInformation = locationData
                                    // parse data here
                                    self.latitude = self.locationInformation[0].lat
                                    self.longitude = self.locationInformation[0].lon
                                    //set self.lat and self.long
                                    self.fetchData()
                                }
                            } catch {
                                print("Error decoding Location JSON: \(error)")
                                //self.isLoading = false
                            }
                        }
                        task.resume()
                    }
                    
                    
                    // call fetchdata as normal
                }
            }
        }
    }
    
}
