import SwiftUI

@main
struct KeyboredApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .fullscreenWindow()
    }
    .windowStyle(.plain)
  }
}

struct FullscreenWindowModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { _ in
          Color.clear
            .onAppear {
              if let window = NSApp.windows.first {
                window.setFrame(NSScreen.main!.frame, display: true)
              }
            }
        }
      )
  }
}

extension View {
  func fullscreenWindow() -> some View {
    self.modifier(FullscreenWindowModifier())
  }
}
