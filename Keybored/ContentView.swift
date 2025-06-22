import AppKit
import SwiftUI

struct ContentView: View {
  @State private var controller = Controller()

  var body: some View {
    ZStack {
      Color.clear
        .background(.ultraThinMaterial)
        .ignoresSafeArea()

      VStack(spacing: 20) {
        Text("Has Permissions: \(controller.hasPermissions ? "✅" : "❌")")
        Text(
          controller.isActive
            ? "Keyboard is Locked 🔒" : "Keyboard is Unlocked 🔓"
        )
        Text(
          "Last Pressed Key: \(controller.lastKeyPressed)"
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
