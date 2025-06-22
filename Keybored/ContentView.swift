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

        Button("Request Accessibility Permissions") {
          controller.requestPermissions()
        }

        Button("Lock Keyboard") {
          controller.startSuppressing()
        }

        Button("Unlock Keyboard") {
          controller.stopSuppressing()
        }
      }
      .controlSize(.extraLarge)
      .padding()
    }
  }
}

#Preview {
  ContentView()
}
