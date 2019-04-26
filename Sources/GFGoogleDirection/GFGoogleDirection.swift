import Vapor

public class GFGoogleDirection: Service {
  var apiKey: String
  
  public init(apiKey: String) {
    self.apiKey = apiKey
  }
  
  public func request(client: Client, request: GoogleDirectionRequest) -> Future<GoogleResponse> {
    let url = request.convertToURL(apiKey: self.apiKey)
    print(url.absoluteString)
    return client.get(url).flatMap { (response) in
      return try response.content.decode(GoogleResponse.self)
    }
  }
}

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

public struct GoogleResponse: Decodable {
  public var waypoints: [Waypoint]
  public var routes: [Route]
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let status = try container.decode(StatusType.self, forKey: .status)
    
    guard status == .ok else {
      let errorMessage = try container.decode(String.self, forKey: .errorMessage)
      throw GoogleDirectionError(status: status, errorMessage: errorMessage)
    }
    
    waypoints = try container.decode([Waypoint].self, forKey: .waypoints)
    routes = try container.decode([Route].self, forKey: .routes)
  }
  
  enum CodingKeys: String, CodingKey {
    case waypoints = "geocoded_waypoints"
    case errorMessage = "error_message"
    
    case routes
    case status
  }
}

struct GoogleDirectionError: Error {
  var status: GoogleResponse.StatusType
  
  /// When the status code is other than **OK**, there may be an additional **errorMessage** field within the Directions response object. This field contains more detailed information about the reasons behind the given status
  var errorMessage: String
}

public extension GoogleResponse {
  public enum StatusType: String, Codable {
    case internalError
    
    // MARK: - Google's Statuses
    
    case ok = "OK"
    case notFound = "NOT_FOUND"
    case zeroResults = "ZERO_RESULTS"
    case maxWaypointsExceeded = "MAX_WAYPOINTS_EXCEEDED"
    case maxRouteLengthExceeded = "MAX_ROUTE_LENGTH_EXCEEDED"
    case invalidRequest = "INVALID_REQUEST"
    case overDailyLimit = "OVER_DAILY_LIMIT"
    case overQueryLimit = "OVER_QUERY_LIMIT"
    case requestDenied = "REQUEST_DENIED"
    case unknownError = "UNKNOWN_ERROR"
  }
}

public extension GoogleResponse {
  public struct Waypoint: Content {
    var status: String
    var placeId: String
    var types: [String]
    
    enum CodingKeys: String, CodingKey {
      case status = "geocoder_status"
      case placeId = "place_id"
      
      case types
    }
  }
}

public struct Route: Content {
  
  /// This polyline is an approximate (smoothed) path of the step
  public var polyline: String
  
  /// contains an array of warnings to be displayed when showing these directions. You must handle and display these warnings yourself
  public var warnings: [String]
  
  /// Each element in the legs array specifies a single leg of the journey from the origin to the destination in the calculated route. For routes that contain no waypoints, the route will consist of a single "leg," but for routes that define one or more waypoints, the route will consist of one or more legs, corresponding to the specific legs of the journey.
  public var legs: [Leg]
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let polylineContainer = try container.nestedContainer(keyedBy: PolylineCodingKeys.self, forKey: .polyline)
    
    polyline = try polylineContainer.decode(String.self, forKey: .points)
    warnings = try container.decode([String].self, forKey: .warnings)
    legs = try container.decode([Leg].self, forKey: .legs)
  }
  
  enum CodingKeys: String, CodingKey {
    case polyline = "overview_polyline"
    case warnings
    case legs
  }
  
  enum PolylineCodingKeys: String, CodingKey {
    case points
  }
}

public struct Leg: Content {
  public var distance: UInt
  public var duration: UInt
  public var durationInTraffic: UInt?
  public var startLocation: Coordinate
  public var endLocation: Coordinate
  public var startAddress: String
  public var endAddress: String
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let distanceExpandedContainer = try container.nestedContainer(keyedBy: ExpandedKeys.self, forKey: .distance)
    let durationExpandedContainer = try container.nestedContainer(keyedBy: ExpandedKeys.self, forKey: .duration)
    
    duration = try durationExpandedContainer.decode(UInt.self, forKey: .value)
    distance = try distanceExpandedContainer.decode(UInt.self, forKey: .value)
    startLocation = try container.decode(Coordinate.self, forKey: .startLocation)
    endLocation = try container.decode(Coordinate.self, forKey: .endLocation)
    startAddress = try container.decode(String.self, forKey: .startAddress)
    endAddress = try container.decode(String.self, forKey: .endAddress)
    
    if container.contains(.durationInTraffic) {
      let durationInTrafficExpandedContainer = try container.nestedContainer(keyedBy: ExpandedKeys.self, forKey: .durationInTraffic)
      durationInTraffic = try durationInTrafficExpandedContainer.decodeIfPresent(UInt.self, forKey: .value)
    }
    
  }
  
  enum CodingKeys: String, CodingKey {
    case distance
    case duration
    case durationInTraffic = "duration_in_traffic"
    case startLocation = "start_location"
    case endLocation = "end_location"
    case startAddress = "start_address"
    case endAddress = "end_address"
  }
  
  enum ExpandedKeys: String, CodingKey {
    case value
    case text
  }
  
}

public struct Coordinate: Content {
  public var latitude: Double
  public var longitude: Double
  
  enum CodingKeys: String, CodingKey {
    case latitude = "lat"
    case longitude = "lng"
  }
}
