//
//  ViewController.swift
//  Weather
//
//  Created by Avish Manocha on 27/03/23.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
  
  let viewModel = WeatherViewModel()
  var searchTask: DispatchWorkItem?
  private var searchController: UISearchController!
  
  @IBOutlet weak private var cityLabel: UILabel!
  @IBOutlet weak private var stateLabel: UILabel!
  @IBOutlet weak private var countryLabel: UILabel!
  @IBOutlet weak private var latitudeLabel: UILabel!
  @IBOutlet weak private var longitudeLabel: UILabel!
  @IBOutlet weak private var windSpeedLabel: UILabel!
  @IBOutlet weak private var weatherTypeLabel: UILabel!
  @IBOutlet weak private var weatherDescriptionLabel: UILabel!
  @IBOutlet weak private var weatherImageView: UIImageView!
  
  private lazy var resultsTableController: LocationResultsTableController = {
    let resultController = self.storyboard?.instantiateViewController(withIdentifier: Constants.LocationResultsTableControllerID) as! LocationResultsTableController
    resultController.tableView.delegate = self
    return resultController
  }()
  
  lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    return locationManager
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setupSearchController()
    bindOutputs()
    fetchUserLocation()
    viewModel.viewDidLoad()
  }
  
  func resetResultsController() {
    if let resultsController = searchController.searchResultsController as? LocationResultsTableController {
      resultsController.filteredLocations = []
      resultsController.tableView.reloadData()
    }
  }

  private func setupSearchController() {
    searchController = UISearchController(searchResultsController: resultsTableController)
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self // Monitor when the search button is tapped.
    searchController.obscuresBackgroundDuringPresentation = false
    // Place the search bar in the navigation bar.
    navigationItem.searchController = searchController
    
    // Make the search bar always visible.
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchBar.placeholder = Constants.searchPlaceholder
  }
  
  private func bindOutputs() {
    viewModel.updateView = { [weak self] location in
      DispatchQueue.main.async {
        self?.updateView(location: location)
      }
    }
    
    viewModel.updateWeatherData = { [weak self] weather in
      DispatchQueue.main.async {
        self?.updateWeatherData(weather: weather)
      }
    }
    
    viewModel.updateImage = { [weak self] data in
      DispatchQueue.main.async {
        self?.weatherImageView.image = UIImage(data: data)
      }
    }
    
    viewModel.reloadResultsTable = { [weak self] in
      DispatchQueue.main.async {
        if let resultsController = self?.searchController.searchResultsController as? LocationResultsTableController {
          resultsController.filteredLocations = self?.viewModel.filteredResults ?? []
         resultsController.tableView.reloadData()
        }
      }
    }
  }
  
  private func fetchUserLocation() {
    guard viewModel.searchText == nil else { return }
    locationManager.requestWhenInUseAuthorization()
  }
  
  private func updateView(location: Location?) {
    guard let location = location else { return }
    cityLabel.text = location.name ?? ""
    stateLabel.text = location.state ?? ""
    countryLabel.text = location.country ?? ""
    if let lat = location.lat, let lon = location.lon {
      latitudeLabel.text = "\(lat)"
      longitudeLabel.text = "\(lon)"
      viewModel.searchText = "\(location.name ?? " ")_\(location.state ?? " ")"
      viewModel.fetchWeatherDetails(of: lat, lon: lon)
    }
  }
  
  private func updateWeatherData(weather: Weather?) {
    weatherTypeLabel.text = weather?.weather?.first?.main ?? ""
    weatherDescriptionLabel.text = weather?.weather?.first?.description ?? ""
    if let speed = weather?.wind?.speed {
      windSpeedLabel.text = "\(speed)"
    }
    viewModel.downloadImage(from: weather?.weather?.first?.icon)
  }

  func presentAlert(message: String) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: Constants.ok, style: UIAlertAction.Style.cancel)
    alert.addAction(okAction)
    present(alert, animated: true)
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    searchController.searchBar.text = ""
    resetResultsController()
    (searchController.searchResultsController as? LocationResultsTableController)?.dismiss(animated: true)
    updateView(location: viewModel.fetchLocation(at: indexPath.row))
  }
}
