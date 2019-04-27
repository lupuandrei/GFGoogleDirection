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
  
  enum CodingKeys: String, CodingKey {
    case waypoints = "geocoded_waypoints"
    case routes
  }
  
  enum StatusCodingKeys: String, CodingKey {
    case errorMessage = "error_message"
    case status
  }
  
}
