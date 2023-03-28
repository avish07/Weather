//
//  LocationResultsTableController.swift
//  Weather
//
//  Created by Avish Manocha on 27/03/23.
//

import UIKit

final class LocationResultsTableController: UITableViewController {

  var filteredLocations: [Location] = [] {
    didSet {
      resultslabel.text = filteredLocations.isEmpty ? "No results found!" : "Location found: \(filteredLocations.count)"
    }
  }
  
  @IBOutlet weak private var resultslabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.tableViewCellID)
  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    filteredLocations.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellID, for: indexPath)
    let location = filteredLocations[indexPath.row]
    cell.textLabel?.text = "\(location.name ?? ""), \(location.state ?? ""), \(location.country ?? "")"
    return cell
  }
}
