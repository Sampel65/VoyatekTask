import Foundation

struct DummyData {
    static let foods = [
        Food(
            id: "1",
            name: "Garlic Butter Shrimp Pasta",
            description: "Creamy hummus spread on whole grain toast topped with sliced cucumbers and radishes, creating a delightful blend of textures and flavors.",
            category: "Dawn Delicacies",
            calories: 320,
            tags: ["healthy", "vegetarian"],
            imageURLs: ["https://example.com/shrimpPasta.jpg"]
        ),
        Food(
            id: "2",
            name: "Lemon Herb Chicken Fettuccine",
            description: "Tender chicken breast served over fettuccine pasta with a light lemon herb sauce.",
            category: "Morning Feast",
            calories: 250,
            tags: ["healthy", "high-protein"],
            imageURLs: ["https://example.com/chickenFettuccine.jpg"]
        ),
        Food(
            id: "3",
            name: "Avocado Toast Supreme",
            description: "Fresh avocado mashed on artisan bread with cherry tomatoes and microgreens.",
            category: "Sunrise Meal",
            calories: 180,
            tags: ["vegan", "breakfast"],
            imageURLs: ["https://example.com/avocadoToast.jpg"]
        )
    ]
}
