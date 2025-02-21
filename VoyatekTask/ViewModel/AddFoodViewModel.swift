class AddFoodViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var category = "Dawn Delicacies"
    @Published var calories = ""
    @Published var tags: [String] = []
    @Published var currentTag = ""
    @Published var selectedPhotos: [UIImage] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func addFood() async {
        guard !name.isEmpty else {
            errorMessage = "Please enter a food name"
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let food = Food(
                id: UUID().uuidString,
                name: name,
                description: description,
                category: category,
                calories: Int(calories) ?? 0,
                tags: tags,
                imageURLs: []
                
            )
            
            let _ = try await APIService.shared.addFood(food)
            
            // Get updated food list
            let _ = try await APIService.shared.getFoods()
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func addTag() {
        guard !currentTag.isEmpty else { return }
        tags.append(currentTag)
        currentTag = ""
    }
    
    func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
}
