//
//  WeatherDetailsView.swift
//  NPS Data Explorer
//
//  Created by Sam Hoag on 2/3/24.
//

import SwiftUI

struct WeatherDetailsView: View {
    let weatherPeriod: WeatherPeriod
    let weatherPoint: WeatherPoint
    @ObservedObject var viewModel: WeatherViewModel
    
    
    var body: some View {
        //TODO This image value to be variable
        
        
        ScrollView {
            
            VStack{
                Spacer(minLength: 55)
                //Text("\(weatherPoint.properties.relativeLocation.properties.city), \(weatherPoint.properties.relativeLocation.properties.state)")
                //    .font(.title)
                // TODO: Need to fix bug where name of a place can differ from weather data shown
                
                Text("\(viewModel.locationInformation[0].city)")
                    .font(.title)
                Text("\(viewModel.locationInformation[0].state)")
                
                Text("\(weatherPeriod.temperature)°")
                    .font(.system(size: 96))
                    .fontWeight(.ultraLight)
                Spacer()
                HStack {
                    
                    //Short weather desc
                    Text(Utilities.writeWeatherShortDesc(data: viewModel.forecastDetailedInformation[0].properties))
                        .font(.title2)
                        .fontWeight(.medium)
                    //Vertical Spacer
                    Rectangle()
                        .frame(width: 2, height: 40) // Vertical bar
                        .foregroundColor(.primary) // Color of the bar
                    // Temp & precip stack
                    VStack(alignment: .leading){
                        HStack{
                            
                            Text("H: \(Utilities.celciusToFahrenheit(c:(viewModel.forecastDetailedInformation[0].properties.maxTemperature.values[0].value) ?? 0))°  L: \(Utilities.celciusToFahrenheit(c:(viewModel.forecastDetailedInformation[0].properties.minTemperature.values[0].value) ?? 0))°")
                                .font(.title3)
                                .fontWeight(.medium)
                            
                        }
                        if let rainPercent = weatherPeriod.probabilityOfPrecipitation.value {
                            HStack {
                                Image(systemName: "cloud.rain")
                                Text("\(rainPercent)%")
                                
                            }
                            
                        } else {
                            // TODO make this less of a bandaid
                            HStack {
                                Image(systemName: "cloud.rain")
                                Text("0%")
                                
                                
                            }
                            
                        }
                    }
                    
                }
                
                //WeatherScrollView(heading: "Hourly Forecast", viewModel: self.viewModel)
                //WeatherScrollView(heading: "10 Day Forecast", viewModel: self.viewModel)
                //Text("\(Utilities.writeWeatherLongDesc(data: viewModel.forecastDetailedInformation[0].properties))").padding()
            }
            
            
        }.refreshable{
            withAnimation {
                viewModel.fetchData()
            }
        }
        
        
        
    }
    
    
}

struct WeatherScrollView: View {
    var heading: String // Declare heading as a parameter
    var vm: WeatherViewModel
    
    init(heading: String, viewModel: WeatherViewModel) { // Add an initializer to initialize the heading
        self.heading = heading
        self.vm = viewModel
    }
    
    var body: some View {
        Text(self.heading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(4)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                // TODO: Iterate over avail. hourly forecast for the location
                ForEach(vm.forecastDetailedInformation[0].properties.temperature.values) { value in
                    //ForEach(0..<10) { index in
                    WeatherWidgetView(temperature: value.value ?? 999, datetime: value.validTime)
                }
            }
        }
    }
}


struct WeatherWidgetView: View {
    var temperature: Int
    var time: Int
    var amPm: String
    
    init(temperature: Float, datetime: String) {
        print(datetime)
        self.temperature = Utilities.celciusToFahrenheit(c: temperature)
        let timeData = Utilities.dateTimeParser(datetime: datetime)
        self.time = timeData.0
        if timeData.1 {
            self.amPm = "a"
        } else {
            self.amPm = "p"
        }
        
    }
    
    var body: some View {
        
        Rectangle()
            .fill(Color.blue)
            .frame(width: 100, height: 100)
            .cornerRadius(5)
            .overlay(
                VStack{
                    Spacer()
                    Text("\(time)\(amPm)")
                    
                    Text("\(temperature)°")
                        .font(.largeTitle)
                    Spacer()
                }
                
            )
    }
}
