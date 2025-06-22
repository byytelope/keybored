import SwiftUI

@Observable class Controller {
  var isActive = false
  var hasPermissions = false
  var interceptedKeysCount = 0
  var lastKeyPressed = ""

  private var eventTap: CFMachPort?
  private var runLoopSource: CFRunLoopSource?

  init() {
    checkPermissions()
  }

  func checkPermissions() {
    hasPermissions = AXIsProcessTrusted()
  }

  func requestPermissions() {
    print("Triggering accessibility permission prompt...")
    let options =
      [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
    let trusted = AXIsProcessTrustedWithOptions(options)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.hasPermissions = trusted
    }
  }

  func startSuppressing() {
    guard hasPermissions else {
      print("No accessibility permissions")
      return
    }

    guard !isActive else { return }

    let eventMask =
      (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
      | (1 << CGEventType.flagsChanged.rawValue)

    eventTap = CGEvent.tapCreate(
      tap: .cgSessionEventTap,
      place: .headInsertEventTap,
      options: .defaultTap,
      eventsOfInterest: CGEventMask(eventMask),
      callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
        let interceptor = Unmanaged<Controller>.fromOpaque(refcon!)
          .takeUnretainedValue()
        return interceptor.handleEvent(proxy: proxy, type: type, event: event)
      },
      userInfo: Unmanaged.passUnretained(self).toOpaque()
    )

    guard let eventTap = eventTap else {
      print("Failed to create event tap")
      return
    }

    runLoopSource = CFMachPortCreateRunLoopSource(
      kCFAllocatorDefault,
      eventTap,
      0
    )
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
    CGEvent.tapEnable(tap: eventTap, enable: true)

    DispatchQueue.main.async {
      self.isActive = true
    }

    print("Started suppressing all keyboard input")
  }

  func stopSuppressing() {
    guard isActive else { return }

    if let eventTap = eventTap {
      CGEvent.tapEnable(tap: eventTap, enable: false)
      CFMachPortInvalidate(eventTap)
    }

    if let runLoopSource = runLoopSource {
      CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
    }

    eventTap = nil
    runLoopSource = nil

    DispatchQueue.main.async {
      self.isActive = false
    }

    print("Stopped suppressing keyboard input")
  }

  private func handleEvent(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent
  ) -> Unmanaged<CGEvent>? {
    if type == .keyDown {
      let keyCode = event.getIntegerValueField(.keyboardEventKeycode)

      DispatchQueue.main.async {
        self.interceptedKeysCount += 1
        let key = keyString(for: keyCode)
        let modifiers = modifierString(for: event.flags)
        self.lastKeyPressed = "Key: \(key), Modifiers: \(modifiers)"
      }
    }

    return nil
  }

  deinit {
    stopSuppressing()
  }
}

private func keyString(for keyCode: Int64) -> String {
  switch keyCode {
  case 0: return "A"
  case 1: return "S"
  case 2: return "D"
  case 3: return "F"
  case 4: return "H"
  case 5: return "G"
  case 6: return "Z"
  case 7: return "X"
  case 8: return "C"
  case 9: return "V"
  case 10: return "Section"
  case 11: return "B"
  case 12: return "Q"
  case 13: return "W"
  case 14: return "E"
  case 15: return "R"
  case 16: return "Y"
  case 17: return "T"
  case 18: return "1"
  case 19: return "2"
  case 20: return "3"
  case 21: return "4"
  case 22: return "6"
  case 23: return "5"
  case 24: return "Equal (=)"
  case 25: return "9"
  case 26: return "7"
  case 27: return "Minus (-)"
  case 28: return "8"
  case 29: return "0"
  case 30: return "Right Bracket (])"
  case 31: return "O"
  case 32: return "U"
  case 33: return "Left Bracket ([)"
  case 34: return "I"
  case 35: return "P"
  case 36: return "Return"
  case 37: return "L"
  case 38: return "J"
  case 39: return "Quote ('')"
  case 40: return "K"
  case 41: return "Semicolon (;)"
  case 42: return "Backslash (\\)"
  case 43: return "Comma (,)"
  case 44: return "Slash (/)"
  case 45: return "N"
  case 46: return "M"
  case 47: return "Period (.)"
  case 48: return "Tab"
  case 49: return "Space"
  case 50: return "Grave (`)"
  case 51: return "Delete"
  case 52: return "Enter (Numpad)"
  case 53: return "Escape"
  case 54: return "Right Command"
  case 55: return "Left Command"
  case 56: return "Left Shift"
  case 57: return "Caps Lock"
  case 58: return "Left Option"
  case 59: return "Left Control"
  case 60: return "Right Shift"
  case 61: return "Right Option"
  case 62: return "Right Control"
  case 63: return "Function (Fn)"
  case 64: return "F17"
  case 65: return "Keypad Decimal"
  case 66: return "Keypad Multiply"
  case 67: return "Keypad Plus"
  case 68: return "Keypad Clear"
  case 69: return "Keypad Divide"
  case 70: return "Keypad Enter"
  case 71: return "Keypad Minus"
  case 72: return "F18"
  case 73: return "F19"
  case 74: return "Keypad Equal"
  case 75: return "Keypad 0"
  case 76: return "Keypad 1"
  case 77: return "Keypad 2"
  case 78: return "Keypad 3"
  case 79: return "Keypad 4"
  case 80: return "Keypad 5"
  case 81: return "Keypad 6"
  case 82: return "Keypad 7"
  case 83: return "Keypad 8"
  case 84: return "Keypad 9"
  case 85: return "JIS Yen"
  case 86: return "JIS Underscore"
  case 87: return "JIS Keypad Comma"
  case 88: return "F5"
  case 89: return "F6"
  case 90: return "F7"
  case 91: return "F3"
  case 92: return "F8"
  case 93: return "F9"
  case 94: return "JIS Eisu"
  case 95: return "F11"
  case 96: return "JIS Kana"
  case 97: return "F13"
  case 98: return "F16"
  case 99: return "F14"
  case 100: return "F10"
  case 101: return "App"
  case 102: return "F12"
  case 103: return "JIS Ro"
  case 104: return "F15"
  case 105: return "Help"
  case 106: return "Home"
  case 107: return "Page Up"
  case 108: return "Forward Delete"
  case 109: return "F4"
  case 110: return "End"
  case 111: return "F2"
  case 112: return "Page Down"
  case 113: return "F1"
  case 114: return "Left Arrow"
  case 115: return "Right Arrow"
  case 116: return "Down Arrow"
  case 117: return "Up Arrow"
  case 118: return "Power"
  case 119: return "Keypad ="
  case 120: return "F20"
  case 121: return "Keypad ."
  case 122: return "Keypad *"
  case 123: return "Keypad +"
  case 124: return "Keypad Clear"
  case 125: return "Keypad /"
  case 126: return "Keypad Enter"
  case 127: return "Keypad -"
  default: return "(Unknown: \(keyCode))"
  }
}

private func modifierString(for flags: CGEventFlags) -> String {
  var components: [String] = []
  if flags.contains(.maskAlphaShift) { components.append("Caps Lock") }
  if flags.contains(.maskShift) { components.append("Shift") }
  if flags.contains(.maskControl) { components.append("Control") }
  if flags.contains(.maskAlternate) { components.append("Option") }
  if flags.contains(.maskCommand) { components.append("Command") }
  if flags.contains(.maskHelp) { components.append("Help") }
  if flags.contains(.maskSecondaryFn) { components.append("Fn") }
  return components.isEmpty ? "None" : components.joined(separator: "+")
}
