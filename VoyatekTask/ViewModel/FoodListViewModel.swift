import Foundation

@MainActor
class FoodListViewModel: ObservableObject {
    @Published var foods: [Food] = DummyData.foods
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    @Published var categories = [
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
    
    func selectCategory(_ name: String) {
        for index in categories.indices {
            categories[index].isSelected = (categories[index].name == name)
        }
    }
    
    var filteredFoods: [Food] {
        let selectedCategory = categories.first { $0.isSelected }?.name
        guard selectedCategory != "All" else { return foods }
        return foods.filter { $0.category == selectedCategory }
    }
    
    func addNewFood(_ food: Food) {
        foods.insert(food, at: 0)
    }
}
