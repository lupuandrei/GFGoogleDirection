import Vapor

public class GoogleDirectionClient: Service {
  let client: Client
  let apiKey: String
  
  public init(apiKey: String, client: Client) {
    self.apiKey = apiKey
    self.client = client
  }
  
  public func request(request: GoogleDirectionRequest) -> Future<GoogleDirectionResponse> {
    let url = request.convertToURL(apiKey: self.apiKey)
    return client.get(url).flatMap { (response) in
      return try response.content.decode(GoogleDirectionResponse.self)
    }
  }
}
