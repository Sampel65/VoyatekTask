import Foundation

struct Food: Identifiable, Codable {
    let id: String
    var name: String
    var description: String
    var category: String
    var calories: Int
    var tags: [String]
    var imageURLs: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case category
        case calories
        case tags
        case imageURLs = "images"
    }
}

struct FoodResponse: Codable {
    let status: String
    let data: [Food]
}

struct FoodCategory: Identifiable {
    let id = UUID()
    let name: String
    let isSelected: Bool
}

