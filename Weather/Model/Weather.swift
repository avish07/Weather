//
//  Weather.swift
//  Weather
//
//  Created by Avish Manocha on 27/03/23.
//

struct Weather: Decodable {
  let weather: [WeatherDetails]?
  let wind: Wind?
}

struct WeatherDetails: Decodable {
  let main, description, icon: String?
}

struct Wind: Decodable {
  let speed: Double?
}

struct Location: Decodable {
  let name, state, country: String?
  let lat, lon: Float?
}
