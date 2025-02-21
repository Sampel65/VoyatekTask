import SwiftUI

struct FoodListView: View {
    @StateObject private var viewModel = FoodListViewModel()
    @State private var searchText = ""
    @State private var showingAddFood = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 16) {
                    // Header with avatar
                    HStack(spacing: 16) {
                        // Avatar image
                        Image("User avatar")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        Spacer()
                        Button(action: {}) {
                            Image("Notification icon")
                                .font(.title2)
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        VStack(alignment: .leading) {
                            Text("Hey there, Lucy!")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Are you excited to create a tasty dish today?")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        }
                        
                        Spacer()
                    }
                    .padding(.leading)
                    
                    
                    // Search bar
                    SearchBar(text: $searchText)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.categories) { category in
                                Button(action: {
                                    viewModel.selectCategory(category.name)
                                }) {
                                    CategoryPill(category: category.name,
                                                isSelected: category.isSelected)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Section title
                    HStack {
                        Text("All Foods")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Food list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredFoods) { food in
                                FoodCard(food: food)
                            }
                        }
                        .padding()
                    }
                }
                
                // Floating Action Button
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Button(action: { showingAddFood = true }) {
//                            Image(systemName: "plus")
//                                .font(.title2)
//                                .foregroundColor(.white)
//                                .frame(width: 60, height: 60)
//                                .background(Color.blue)
//                                .clipShape(Circle())
//                                .shadow(radius: 5)
//                        }
//                        .padding(.trailing, 20)
//                        .padding(.bottom, 80)
//                    }
//                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddFood) {
            AddFoodView()
        }
        .task {
            await viewModel.loadFoods()
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search foods...", text: $text)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct CategoryPill: View {
    let category: String
    let isSelected: Bool
    
    var body: some View {
        Text(category)
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(10)
    }
}

struct FoodCard: View {
    let food: Food
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            if let imageURL = food.imageURLs.first {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(height: 200)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(food.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.red)
                    Text("\(food.calories) Calories")
                        .font(.subheadline)
                }
                
                Text(food.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                // Tags
                HStack {
                    ForEach(food.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}



#Preview {
    FoodListView()
}
