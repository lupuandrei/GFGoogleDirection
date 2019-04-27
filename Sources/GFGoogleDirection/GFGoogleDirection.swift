import Vapor

public class GFGoogleDirection: Service {
  var apiKey: String
  
  public init(apiKey: String) {
    self.apiKey = apiKey
  }
  
  public func request(client: Client, request: GoogleDirectionRequest) -> Future<GoogleDirectionResponse> {
    let url = request.convertToURL(apiKey: self.apiKey)
    return client.get(url).flatMap { (response) in
      return try response.content.decode(GoogleDirectionResponse.self)
    }
  }
}
