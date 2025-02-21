import Foundation

struct Food: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let category: String
    let calories: Int
    let tags: [String]
    let imageURLs: [String]
    
    var rating: Double { 4.5 }
    var numberOfRatings: Int { 120 }
    var price: Double { 15.99 }
    var cookTime: String { "25-30 min" }
    var distance: String { "1.2 km" }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case category
        case calories
        case tags
        case imageURLs
    }
}

struct FoodResponse: Codable {
    let status: String
    let data: [Food]
}

struct FoodCategory: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}
