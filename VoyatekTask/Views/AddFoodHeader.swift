import SwiftUI

struct AddFoodHeader: View {
    let dismiss: () -> Void
    
    var body: some View {
        HStack {
            Button(action: dismiss) {
                Image( "back1")
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
