import Foundation

extension GoogleDirectionResponse {
  public struct Waypoint: Decodable {
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

