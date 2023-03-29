//
//  CityViewModel.swift
//  Weather
//
//  Created by Avish Manocha on 27/03/23.
//

import Foundation

final class WeatherViewModel {

  var updateView: ((Location?) -> Void)?
  var updateWeatherData: ((Weather?) -> Void)?
  var updateImage: ((Data) -> Void)?
  var reloadResultsTable: (() -> Void)?
  private var location: [Location]?
  private var weather: Weather?

  var searchText: String? {
    get {
      UserDefaults.standard.string(forKey: Constants.searchText)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Constants.searchText)
    }
  }

  var selectedCity: String? {
    searchText?.components(separatedBy: "_").first
  }

  var selectedState: String? {
    searchText?.components(separatedBy: "_").last
  }

  func viewDidLoad() {
    if let selectedCity = selectedCity, !selectedCity.isEmpty {
      fetchLocationDetails(for: selectedCity, isAutoload: true)
    }
  }

  func fetchReverseLocationDetails(for lat: Float, lon: Float) {
    let urlString = "\(Constants.weatherBaseURL)/geo/1.0/reverse?lat=\(lat)&lon=\(lon)&limit=15&appid=\(Constants.openWeatherAPIKey)"
    WebServiceHelper.get(dataOf: urlString, of: [Location].self) { [weak self] response in
      switch response {
      case .success(let location):
        self?.location = location
        self?.updateView?(self?.location?.first)
      case.failure(_): break
      }
    }
  }

  func fetchLocationDetails(for searchText: String, isAutoload: Bool = false) {
    let urlString = "\(Constants.weatherBaseURL)/geo/1.0/direct?q=\(searchText)&limit=15&appid=\(Constants.openWeatherAPIKey)"
    WebServiceHelper.get(dataOf: urlString, of: [Location].self) { [weak self] response in
      switch response {
      case .success(let location):
        self?.location = location
        if isAutoload {
          if let location = self?.filteredResults?.first(where: {
            $0.name == self?.selectedCity && $0.state == self?.selectedState
          }) {
            self?.updateView?(location)
          }
        } else {
          self?.reloadResultsTable?()
        }
      case.failure(_): break
      }
    }
  }

  func fetchWeatherDetails(of lat: Float, lon: Float) {
    let urlString = "\(Constants.weatherBaseURL)/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.openWeatherAPIKey)"
    WebServiceHelper.get(dataOf: urlString, of: Weather.self) { [weak self] response in
      switch response {
      case .success(let weather):
        self?.weather = weather
        self?.updateWeatherData?(weather)
      case.failure(_): break
      }
    }
  }

  func downloadImage(from icon: String?) {
    guard let icon = icon else { return }
    WebServiceHelper.downloadImage(from: "\(Constants.imageBaseURL)/\(icon)@2x.png") { [weak self] data in
      self?.updateImage?(data)
    }
  }

  func fetchLocation(at index: Int) -> Location? {
    filteredResults?[index]
  }

  var filteredResults: [Location]? {
    location?.filter{ $0.country ?? "" == Constants.usaCountryCode }
  }
}
