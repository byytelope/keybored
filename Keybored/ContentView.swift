import SwiftUI


struct ContentView: View {
  @State private var controller = Controller()

  var body: some View {
    ZStack {
      Color.clear
        .background(.ultraThinMaterial)
        .ignoresSafeArea()

      VStack(spacing: 20) {
        KeyPreview(
          lastKey: $controller.lastKey,
          modifiers: $controller.lastModifiers
        )

        Button("Lock Keyboard") {
          controller.startSuppressing()
        }
        .disabled(controller.isActive)

        Button("Unlock Keyboard") {
          controller.stopSuppressing()
        }
        .disabled(!controller.isActive)
      }
      .controlSize(.extraLarge)
      .padding()
      .confirmationDialog(
        "Accessibility Permission Required",
        isPresented: $controller.showAlert
      ) {
        Button(role: .confirm) {
          controller.openAccessibilitySettings()
        } label: {
          Text("Open Settings")
        }
      } message: {
        Text(
          "Accessibility permission is required to lock keyboard."
        )
      }
    }
  }
}

#Preview {
  ContentView()
}
