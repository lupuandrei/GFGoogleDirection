import Vapor

extension GoogleDirectionResponse {
  
  public struct Readable: Content {
    public var waypoints: [Waypoint]
    
    public var polyline: String
    
    public var distance: UInt
    public var duration: UInt
    public var durationInTraffic: UInt?
    public var startLocation: Coordinate
    public var endLocation: Coordinate
    public var startAddress: String
    public var endAddress: String
  
    init(waypoints: [Waypoint] = [], polyline: String,
         distance: UInt, duration: UInt, durationInTraffic: UInt? = nil,
         startLocation: Coordinate, endLocation: Coordinate,
         startAddress: String, endAddress: String) {
      self.waypoints = waypoints
      self.polyline = polyline
      self.distance = distance
      self.duration = duration
      self.durationInTraffic = durationInTraffic
      self.startLocation = startLocation
      self.endLocation = endLocation
      self.startAddress = startAddress
      self.endAddress = endAddress
    }
  }

}
