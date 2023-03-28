//
//  ViewController+Location.swift
//  Weather
//
//  Created by Avish Manocha on 28/03/23.
//

import CoreLocation

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      viewModel.fetchReverseLocationDetails(for: Float(location.coordinate.latitude), lon: Float(location.coordinate.longitude))
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .authorizedWhenInUse {
      manager.requestLocation()
    } else if manager.authorizationStatus == .denied {
      presentAlert(message: Constants.locationPersmission)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    presentAlert(message: error.localizedDescription)
  }
}
