//
//  WeatherView.swift
//  NPS Data Explorer
//
//  Created by Sam Hoag on 2/3/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Text("Weather Forecast")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                HStack{
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("San Diego, CA")
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                if viewModel.isLoading {
                    Text("Loading...")
                    Spacer()
                } else {
                    
                    VStack{
                        
                        List {
                            ForEach(viewModel.forecastItems) { item in
                                NavigationLink(destination: WeatherDetails(weatherPeriod: item, weatherPoint: viewModel.forecastInformation[0]))
                                {
                                    VStack(alignment: .leading) {
                                        Text(item.name).font(.title)
                                        HStack{
                                            Text("\(item.temperature)°F")
                                            Text("Wind \(item.windSpeed) \(item.windDirection)")
                                        }
                                        
                                        Text(item.shortForecast)
                                            .font(.caption)
                                        
                                    }
                                }
                            }
                        }
                        .refreshable{
                            withAnimation {
                                viewModel.fetchData()
                            }
                        }
                        .listStyle(PlainListStyle())
                        
                    }
                }
            }
            
        }
        .padding()
        
        
    }
    
    // Date formatter for displaying dates
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

