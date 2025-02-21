import SwiftUI

struct CategoryPicker: View {
    @Binding var selectedCategory: String
    let categories = ["Dawn Delicacies", "Morning Feast", "Sunrise Meal"]
    
    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button(category) {
                    selectedCategory = category
                }
            }
        } label: {
            HStack {
                Text(selectedCategory)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
    }
}
