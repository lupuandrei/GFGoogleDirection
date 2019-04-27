import Foundation

extension GoogleDirectionResponse {
  public struct Leg: Decodable {
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
}

