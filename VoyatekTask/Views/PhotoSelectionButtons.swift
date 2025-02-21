import SwiftUI

struct PhotoSelectionButtons: View {
    let onCameraTap: () -> Void
    let onUploadTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            PhotoButton(
                icon: "camera",
                title: "Take photo",
                action: onCameraTap
            )
            
            PhotoButton(
                icon: "arrow.up.square",
                title: "Upload",
                action: onUploadTap
            )
        }
        .padding(.horizontal)
    }
}

struct PhotoButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
    }
}
