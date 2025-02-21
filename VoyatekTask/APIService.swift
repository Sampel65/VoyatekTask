import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}

class APIService {
    static let shared = APIService()
    private let baseURL = "https://your-api-endpoint.com/api"
    
    func getFoods() async throws -> [Food] {
        guard let url = URL(string: "\(baseURL)/foods") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            let foodResponse = try JSONDecoder().decode(FoodResponse.self, from: data)
            return foodResponse.data
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    func addFood(_ food: Food) async throws -> Food {
        guard let url = URL(string: "\(baseURL)/foods") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(food)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode(Food.self, from: data)
    }
}

