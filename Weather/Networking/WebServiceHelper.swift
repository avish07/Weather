//
//  WebServiceHelper.swift
//  Weather
//
//  Created by Avish Manocha on 27/03/23.
//

import Alamofire

enum APIError: Error {
  case noData
}

enum WebServiceHelper {
  static func get<T: Decodable>(dataOf urlString: String, of: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      completion(.failure(APIError.noData))
      return
    }
    AF.request(urlString).validate()
      .responseDecodable(of: T.self) { response in
        if let value = response.value {
          completion(.success(value))
        } else {
          completion(.failure(APIError.noData))
        }
      }
  }
  
  static func downloadImage(from urlString: String, completion: @escaping (Data) -> Void) {
    AF.download(urlString).responseData { response in
      if let value = response.value {
        completion(value)
      }
    }
  }
}
