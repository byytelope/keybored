import SwiftUI

struct KeyPreview: View {
  @Binding var lastKey: String
  @Binding var modifiers: [String]

  var body: some View {
    let isVisible = !lastKey.isEmpty || !modifiers.isEmpty

    HStack(spacing: 8) {
      ForEach(modifiers, id: \.self) { modifier in
        Text(modifier)
          .font(.title.bold())
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(.thinMaterial)
          .cornerRadius(8)
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.primary.opacity(0.1), lineWidth: 1)
          )
          .opacity(isVisible ? 1 : 0)
          .blur(radius: isVisible ? 0 : 20)
          .animation(.easeInOut(duration: 0.3), value: isVisible)
          .animation(.easeInOut(duration: 0.3), value: modifier)

      }
      HStack {
        if !modifiers.isEmpty {
          Text("+")
            .font(.subheadline)
            .opacity(isVisible ? 1 : 0)
            .blur(radius: isVisible ? 0 : 20)
            .animation(.easeInOut(duration: 0.3), value: isVisible)
        }

        Text(lastKey)
          .font(.title.bold())
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(.thinMaterial)
          .cornerRadius(8)
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.primary.opacity(0.1), lineWidth: 1)
          )
          .opacity(isVisible ? 1 : 0)
          .blur(radius: isVisible ? 0 : 20)
          .animation(.easeInOut(duration: 0.3), value: isVisible)
          .animation(.easeInOut(duration: 0.3), value: lastKey)
      }
    }
    .frame(minHeight: 100)
  }
}

struct KeyPreviewContainer: View {
  @State private var lastKey: String = "P"
  @State private var modifiers: [String] = ["Shift", "Control"]

  var body: some View {
    KeyPreview(lastKey: $lastKey, modifiers: $modifiers)
  }
}

#Preview {
  KeyPreviewContainer()
    .frame(width: 300, height: 300)
}
