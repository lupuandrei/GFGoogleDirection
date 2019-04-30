import Vapor

extension GoogleDirectionResponse {
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
  }
}

// MARK: - CodingKeys
extension GoogleDirectionResponse.Route {
  enum CodingKeys: String, CodingKey {
    case polyline = "overview_polyline"
    case warnings
    case legs
  }
  
  enum PolylineCodingKeys: String, CodingKey {
    case points
  }
}
