import SwiftUI
import PhotosUI

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
        // Implementation for adding food
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

struct AddFoodView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AddFoodViewModel()
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    
    var body: some View {
        NavigationView {
            Form {
                // Photo section
                Section {
                    HStack {
                        Button(action: { showingCamera = true }) {
                            VStack {
                                Image(systemName: "camera")
                                    .font(.title)
                                Text("Take photo")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        
                        Button(action: { showingImagePicker = true }) {
                            VStack {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title)
                                Text("Upload")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Selected photos
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.selectedPhotos, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(alignment: .topTrailing) {
                                        Button(action: {
                                            viewModel.selectedPhotos.removeAll { $0 == image }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white)
                                                .background(Color.black)
                                                .clipShape(Circle())
                                        }
                                        .padding(4)
                                    }
                            }
                        }
                    }
                }
                
                // Food details
                Section {
                    TextField("Enter food name", text: $viewModel.name)
                    TextField("Enter food description", text: $viewModel.description)
                    Picker("Category", selection: $viewModel.category) {
                        Text("Dawn Delicacies").tag("Dawn Delicacies")
                        Text("Morning Feast").tag("Morning Feast")
                        Text("Sunrise Meal").tag("Sunrise Meal")
                    }
                    TextField("Enter number of calories", text: $viewModel.calories)
                        .keyboardType(.numberPad)
                }
                
                // Tags
                Section(header: Text("Tags")) {
                    HStack {
                        TextField("Add a tag", text: $viewModel.currentTag)
                            .onSubmit {
                                viewModel.addTag()
                            }
                        Button("Add") {
                            viewModel.addTag()
                        }
                    }
                    
                    FlowLayout(spacing: 8) {
                        ForEach(viewModel.tags, id: \.self) { tag in
                            Text(tag)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(alignment: .topTrailing) {
                                    Button(action: { viewModel.removeTag(tag) }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.caption)
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Add new food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add food") {
                        Task {
                            await viewModel.addFood()
                            dismiss()
                        }
                    }
                    .disabled(viewModel.name.isEmpty)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            PhotosPicker(selection: .constant([]), matching: .images) { result in
                // Handle photo selection
            }
        }
        .sheet(isPresented: $showingCamera) {
            ImagePicker(sourceType: .camera) { image in
                if let image = image {
                    viewModel.selectedPhotos.append(image)
                }
            }
        }
    }
}

// Helper views
struct FlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX,
                                     y: bounds.minY + result.frames[index].minY),
                         proposal: ProposedViewSize(result.frames[index].size))
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var frames: [CGRect] = []
        
        init(in width: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var origin = CGPoint.zero
            var rowHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if origin.x + size.width > width, origin.x > 0 {
                    origin.x = 0
                    origin.y += rowHeight + spacing
                    rowHeight = 0
                }
                
                frames.append(CGRect(origin: origin, size: size))
                rowHeight = max(rowHeight, size.height)
                origin.x += size.width + spacing
                
                if origin.x > width {
                    origin.x = 0
                    origin.y += rowHeight + spacing
                    rowHeight = 0
                }
            }
            
            size = CGSize(width: width,
                         height: origin.y + rowHeight)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let completionHandler: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(completionHandler: completionHandler)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let completionHandler: (UIImage?) -> Void
        
        init(completionHandler: @escaping (UIImage?) -> Void) {
            self.completionHandler = completionHandler
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                 didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image = info[.originalImage] as? UIImage
            completionHandler(image)
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            completionHandler(nil)
            picker.dismiss(animated: true)
        }
    }
}

