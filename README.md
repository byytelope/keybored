# Keybored

Swift-based controller to monitor and suppress all keyboard input on macOS using accessibility and event taps.

## Features
- Toggle keyboard input suppression
- Display the last key pressed (with modifiers)
- Manage accessibility permissions and prompt the user if needed

## Requirements
- **macOS** >= 14
- **Xcode** latest stable

## Setup & Usage
1. **Clone and open the project in Xcode.**
2. **Build and run the project.**
3. **Grant Accessibility permissions** when prompted.
4. **Use the app interface to toggle keyboard suppression.**

## How It Works
- The `Controller` class sets up a CGEventTap at the session level to intercept keyboard events.
- It checks if your app has the necessary Accessibility permissions.
- Intercepted keystrokes are counted, and both the key and any modifiers are displayed.

## Security & Permissions
This app requires Accessibility permissions to function. Go to **System Settings > Privacy & Security > Accessibility** and add this app if it does not appear automatically, or if the popup does not show.

---

**Note:** A secondary input device (mouse, trackpad etc.) is required to unlock the keyboard after it is locked. More options to handle this will be added soon.
