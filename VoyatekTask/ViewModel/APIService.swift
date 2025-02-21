import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingError(let error):
            return "Data decoding error: \(error.localizedDescription)"
        case .serverError(let message):
            return message
        }
    }
}

struct APIResponse<T: Codable>: Codable {
    let status: String
    let message: String
    let data: T
}

class APIService {
    static let shared = APIService()
    private let baseURL = "https://ca1a839b0f8a1647ac99.free.beeceptor.com/api"
    
    private func createRequest(for url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func getFoods() async throws -> [Food] {
        guard let url = URL(string: "\(baseURL)/users") else {
            throw APIError.invalidURL
        }
        
        let request = createRequest(for: url, method: "GET")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let foods = try? decoder.decode([Food].self, from: data) {
                    return foods
                }
                
                if let food = try? decoder.decode(Food.self, from: data) {
                    return [food]
                }
                
                throw APIError.decodingError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to decode response"]))
            } else {
                throw APIError.serverError("Server returned status code: \(httpResponse.statusCode)")
            }
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func addFood(_ food: Food) async throws -> Food {
        guard let url = URL(string: "\(baseURL)/users") else {
            throw APIError.invalidURL
        }
        
        var request = createRequest(for: url, method: "POST")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(food)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                return food
            } else {
                throw APIError.serverError("Server returned status code: \(httpResponse.statusCode)")
            }
        } catch {
            throw APIError.networkError(error)
        }
    }
}
