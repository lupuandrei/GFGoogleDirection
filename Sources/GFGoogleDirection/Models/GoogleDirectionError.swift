import Foundation

struct GoogleDirectionError: Error {
  var status: GoogleDirectionResponse.StatusType
  
  /// When the status code is other than **OK**, there may be an additional **errorMessage** field within the Directions response object. This field contains more detailed information about the reasons behind the given status
  var errorMessage: String
}
