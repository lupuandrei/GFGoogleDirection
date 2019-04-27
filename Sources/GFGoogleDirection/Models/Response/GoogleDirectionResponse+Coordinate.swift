import Vapor

extension GoogleDirectionResponse {
  public struct Coordinate: Content {
    public var latitude: Double
    public var longitude: Double
    
    enum CodingKeys: String, CodingKey {
      case latitude = "lat"
      case longitude = "lng"
    }
  }
}
