//
//  ViewController+SearchController.swift
//  Weather
//
//  Created by Avish Manocha on 28/03/23.
//

import UIKit

extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    searchTask?.cancel()
    let strippedString =
    searchController.searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    guard !strippedString.isEmpty else { return }
    searchTask = DispatchWorkItem { [weak self] in
      self?.viewModel.fetchLocationDetails(for: strippedString)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchTask!)
  }
}

extension ViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    resetResultsController()
  }
}
