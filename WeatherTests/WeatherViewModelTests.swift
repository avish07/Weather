//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by Avish Manocha on 28/03/23.
//

import XCTest
@testable import Weather

final class WeatherViewModelTests: XCTestCase {

  private var sut: WeatherViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = WeatherViewModel()
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  func test_LocationDetails_returnsTrue() {
    let expectation = expectation(description: "Location details")
    sut.reloadResultsTable = { [weak self] in
      XCTAssertNotNil(self?.sut.filteredResults)
      XCTAssertTrue(!(self?.sut.filteredResults?.isEmpty ?? false))
      XCTAssertEqual(self?.sut.filteredResults?.first?.name, "Boston")
      expectation.fulfill()
    }
    sut.fetchLocationDetails(for: "Boston")
    wait(for: [expectation], timeout: 5.0)
  }

  func test_LocationDetails_returnsFalse() {
    let expectation = expectation(description: "Location details")
    sut.reloadResultsTable = { [weak self] in
      XCTAssertNotNil(self?.sut.filteredResults)
      XCTAssertFalse(!(self?.sut.filteredResults?.isEmpty ?? false))
      XCTAssertNotEqual(self?.sut.filteredResults?.first?.name, "xyz")
      expectation.fulfill()
    }
    sut.fetchLocationDetails(for: "xyz")
    wait(for: [expectation], timeout: 5.0)
  }

  func test_ReverseLocationDetails_returnsTrue() {
    let expectation = expectation(description: "Reverse Location details")
    sut.updateView = { location in
      XCTAssertNotNil(location)
      XCTAssertEqual(location?.name, "Boston")
      XCTAssertEqual(location?.country, "US")
      expectation.fulfill()
    }
    sut.fetchReverseLocationDetails(for: 42.355434, lon: -71.06051)
    wait(for: [expectation], timeout: 5.0)
  }

  func test_ReverseLocationDetails_returnsFalse() {
    let expectation = expectation(description: "Reverse Location details")
    sut.updateView = { location in
      XCTAssertNil(location)
      XCTAssertNotEqual(location?.name, "Boston")
      XCTAssertNotEqual(location?.country, "US")
      expectation.fulfill()
    }
    sut.fetchReverseLocationDetails(for: 22.355434, lon: -21.06051)
    wait(for: [expectation], timeout: 5.0)
  }

  func test_WeatherDetails_returnsTrue() {
    let expectation = expectation(description: "Weather details")
    sut.updateWeatherData = { weather in
      XCTAssertNotNil(weather)
      XCTAssertEqual(weather?.weather?.first?.main, "Clouds")
      XCTAssertEqual(weather?.weather?.first?.description, "overcast clouds")
      expectation.fulfill()
    }
    sut.fetchWeatherDetails(of: 42.355434, lon: -71.06051)
    wait(for: [expectation], timeout: 5.0)
  }

  func test_WeatherDetails_returnsFalse() {
    let expectation = expectation(description: "Weather details")
    sut.updateWeatherData = { weather in
      XCTAssertNotNil(weather)
      XCTAssertNotEqual(weather?.weather?.first?.main, "Clear")
      XCTAssertNotEqual(weather?.weather?.first?.description, "Clear Sky")
      expectation.fulfill()
    }
    sut.fetchWeatherDetails(of: 42.355434, lon: -71.06051)
    wait(for: [expectation], timeout: 5.0)
  }

  func test_DownloadImage_returnsTrue() {
    let expectation = expectation(description: "Download Image")
    sut.updateImage = { data in
      XCTAssertNotNil(data)
      expectation.fulfill()
    }
    sut.downloadImage(from: "04d")
    wait(for: [expectation], timeout: 5.0)
  }
}
