import Foundation

public struct GoogleDirectionRequest {
  internal let baseURL = "https://maps.googleapis.com/maps/api/directions/json"
  
  public var startLatitude: Double
  public var startLongitude: Double
  
  public var endLatitude: Double
  public var endLongitude: Double
  
  public var language: String = "en-US"
  public var mode: ModeType = .driving
  public var unitsType: UnitsType = .metric
  public var avoid: AvoidType?
  
  public init(startLatitude: Double, startLongitude: Double,
              endLatitude: Double, endLongitude: Double) {
    self.startLatitude = startLatitude
    self.startLongitude = startLongitude
    self.endLatitude = endLatitude
    self.endLongitude = endLongitude
  }
  
  internal func convertToURL(apiKey: String) -> URL {
    var urlComponents = URLComponents(string: baseURL)!
    var queryItems: [URLQueryItem] = []
    
    let apiKeyQueryItem = URLQueryItem(name: "key", value: apiKey)
    queryItems.append(apiKeyQueryItem)
    
    let startQueryItem = URLQueryItem(name: "origin", value: "\(startLatitude),\(startLongitude)")
    queryItems.append(startQueryItem)
    
    let endQueryItem = URLQueryItem(name: "destination", value: "\(endLatitude),\(endLongitude)")
    queryItems.append(endQueryItem)
    
    let languageQueryItem = URLQueryItem(name: "language", value: language)
    let modeQueryItem = mode.queryItem
    let unitsQueryItem = unitsType.queryItem
    queryItems.append(contentsOf: [languageQueryItem, modeQueryItem, unitsQueryItem])
    
    if let avoidQueryItem = avoid?.queryItem {
      queryItems.append(avoidQueryItem)
    }
    
    urlComponents.queryItems = queryItems
    return urlComponents.url!
  }
}

// MARK: -
public extension GoogleDirectionRequest {
  
  public enum ModeType: String {
    case driving
    case walking
    case bicycling
    case transit
    
    var queryItem: URLQueryItem {
      return URLQueryItem(name: "mode", value: self.rawValue)
    }
  }
  
  public enum UnitsType: String {
    case metric
    case imperial
    
    var queryItem: URLQueryItem {
      return URLQueryItem(name: "units", value: self.rawValue)
    }
  }
  
  public enum AvoidType: String {
    case tolls
    case highways
    case ferries
    case indoor
    
    var queryItem: URLQueryItem {
      return URLQueryItem(name: "avoid", value: self.rawValue)
    }
  }
  
}

