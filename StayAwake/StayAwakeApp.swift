import SwiftUI
import IOKit.pwr_mgt

@main
struct StayAwakeApp: App {
    @AppStorage("stayAwake") var stayAwake: Bool = false
    @State var assertionID: IOPMAssertionID = 0
    @State var showErrorAlert: Bool = false

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)

        if stayAwake {
            var id: IOPMAssertionID = 0

            if IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString, IOPMAssertionLevel(kIOPMAssertionLevelOn), "StayAwake: Disabling screen sleep" as CFString, &id) != kIOReturnSuccess {
                showErrorAlert = true
            }

            self._assertionID = State(initialValue: id)
        }
    }

    var body: some Scene {
        MenuBarExtra {
            ContentView(assertionID: $assertionID, showErrorAlert: $showErrorAlert)
        } label: {
            if stayAwake {
                Image(systemName: "sun.max")
            } else {
                Image(systemName: "sleep")
            }
        }
        .menuBarExtraStyle(.menu)
    }
}
