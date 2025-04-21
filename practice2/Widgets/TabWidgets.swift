import SwiftUI

struct TabButton: View {
    var image: String
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: image)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(title)
                    .font(.custom("Avenir", size: 10))
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                isSelected ? Color.blue.opacity(0.1) : Color.clear
            )
            .cornerRadius(15)
        }
    }
}
                                            // Shared namespace for matched geometry effects
class NamespaceManager {
    // Not recommended to share namespaces, but if you must:
    static var sharedNamespace: Namespace.ID?
}
