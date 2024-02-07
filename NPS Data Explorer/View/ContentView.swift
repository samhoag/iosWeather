//
//  ContentView.swift
//  NPS Data Explorer
//
//  Created by Sam Hoag on 1/30/24.
//

import SwiftUI


struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image(Utilities.selectBackground(timeHour24: 15))
                    .resizable()
                
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .clipped()
                    .ignoresSafeArea(edges: .vertical)
                VStack{
                    if viewModel.isLoading {
                        VStack{
                            Spacer(minLength: 2)
                            Text("Loading...")
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                    } else {
                        WeatherDetailsView(weatherPeriod: viewModel.forecastItems[0], weatherPoint: viewModel.forecastInformation[0], viewModel: viewModel)
                    }
                    SearchBar(viewModel: viewModel)
                }
            }
        }
    }
    
}

struct SearchBar: View {
    @State private var ti_location: String = ""
    var viewModel: WeatherViewModel
    
    var body: some View {
        HStack{
            TextField("Location", text: $ti_location)
                .padding(.vertical, 28)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.gray.opacity(0.7)) // Set the background color
                        .padding()
                )
                .padding(.vertical, 28)
                .foregroundColor(Color.primary.opacity(0.8))
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                viewModel.fetchLatLong(query: self.ti_location)
                ti_location = ""
            }) {
                
                Image(systemName: "magnifyingglass") // SF Symbol
                    .font(.system(size: 30))
                
                    .padding(.trailing)
                    .foregroundColor(Color.gray.opacity(0.5))
                
                    .cornerRadius(10)
            }
            Spacer()
        }
        
    }

}

struct WeatherDetails: View {
    @StateObject var viewModel = WeatherViewModel()
    let weatherPeriod: WeatherPeriod
    let weatherPoint: WeatherPoint
    
    var body: some View {
        //Text("Hello, world!")
        WeatherDetailsView(weatherPeriod: weatherPeriod , weatherPoint: weatherPoint, viewModel: viewModel)
        
    }
}

#Preview {
    ContentView()
}
