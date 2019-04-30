import Vapor

public struct GoogleDirectionResponse: Content {
  public var waypoints: [Waypoint]
  public var routes: [Route]
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let statusContainer = try decoder.container(keyedBy: StatusCodingKeys.self)
    
    let status = try statusContainer.decode(StatusType.self, forKey: .status)
    
    guard status == .ok else {
      let errorMessage = try statusContainer.decode(String.self, forKey: .errorMessage)
      throw GoogleDirectionError(status: status, errorMessage: errorMessage)
    }
    
    waypoints = try container.decode([Waypoint].self, forKey: .waypoints)
    routes = try container.decode([Route].self, forKey: .routes)
  }
  
}

// MARK: - Readable
extension GoogleDirectionResponse {
  public func convertToReadable() throws -> Readable {
    // the response must contain a route and one leg
    guard let route = routes.first, let leg = route.legs.first else {
      throw GoogleDirectionError(status: .internalError, errorMessage: "Invalid response")
    }
    
    return Readable(waypoints: waypoints, polyline: route.polyline, distance: leg.distance, duration: leg.duration, durationInTraffic: leg.durationInTraffic, startLocation: leg.startLocation, endLocation: leg.endLocation, startAddress: leg.startAddress, endAddress: leg.endAddress)
  }
}

// MARK: - CodingKeys
extension GoogleDirectionResponse {
  enum CodingKeys: String, CodingKey {
    case waypoints = "geocoded_waypoints"
    case routes
  }
  
  enum StatusCodingKeys: String, CodingKey {
    case errorMessage = "error_message"
    case status
  }
}
