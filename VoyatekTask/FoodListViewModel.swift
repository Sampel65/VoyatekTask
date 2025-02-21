import Foundation

@MainActor
class FoodListViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    @Published var selectedCategory: String? = nil
    
    let categories = [
        FoodCategory(name: "All", isSelected: true),
        FoodCategory(name: "Morning Feast", isSelected: false),
        FoodCategory(name: "Sunrise Meal", isSelected: false),
        FoodCategory(name: "Dawn Delicacies", isSelected: false)
    ]
    
    func loadFoods() async {
        isLoading = true
        do {
            foods = try await APIService.shared.getFoods()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    var filteredFoods: [Food] {
        guard let category = selectedCategory, category != "All" else {
            return foods
        }
        return foods.filter { $0.category == category }
    }
}

