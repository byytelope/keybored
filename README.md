# Keybored

This project provides a Swift-based controller to monitor and suppress all keyboard input on macOS using accessibility permissions and event taps.

## Features
- Start and stop keyboard input suppression
- Count intercepted keys
- Display the last key pressed (with modifiers)
- Manage accessibility permissions and prompt the user if needed

## Requirements
- macOS (latest version recommended)
- Xcode with Swift support
- Accessibility permissions enabled (System Settings > Privacy & Security > Accessibility)

## Setup & Usage
1. **Clone or open the project in Xcode.**
2. **Build and run the project.**
3. **Grant Accessibility permissions** when prompted on first launch, or use the provided permission request functionality.
4. **Use the app interface to start/stop keyboard suppression.**

## How It Works
- The `Controller` class sets up a CGEventTap at the session level to intercept keyboard events.
- It ensures your app has the necessary Accessibility permissions.
- Intercepted keystrokes are counted, and both the key and any modifiers are displayed.

## Security & Permissions
This app requires Accessibility permissions to function. Go to **System Settings > Privacy & Security > Accessibility** and add this app if it does not appear automatically.

---

**Note:** Modifying system-wide keyboard input can affect user experience and accessibility. Use responsibly.
