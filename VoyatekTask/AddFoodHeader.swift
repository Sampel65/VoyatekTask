import SwiftUI

struct AddFoodHeader: View {
    let dismiss: () -> Void
    
    var body: some View {
        HStack {
            Button(action: dismiss) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
            Spacer()
            Text("Add new food")
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal)
    }
}
