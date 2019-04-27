import Foundation

public extension GoogleDirectionResponse {
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
