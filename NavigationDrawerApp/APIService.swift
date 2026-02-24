import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
}

final class APIService {
    static let shared = APIService()

    private init() {}

    private let endpoint = "https://demo.socialnetworking.solutions/sesapi/navigation?restApi=Sesapi&sesapi_platform=1&auth_token=B179086bb56c32731633335762"

    func fetchNavigation() async throws -> NavigationResponse {
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw APIError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(NavigationResponse.self, from: data)
            return decoded
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
