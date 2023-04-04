import SwiftUI
import IOKit.pwr_mgt

struct ContentView: View {
    @AppStorage("stayAwake") var stayAwake: Bool = false
    @Binding var assertionID: IOPMAssertionID
    @Binding var showErrorAlert: Bool

    var body: some View {
        Button(buttonTitle()) {
            if stayAwake {
                IOPMAssertionRelease(assertionID)

                stayAwake = false
            } else {
                if IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString, IOPMAssertionLevel(kIOPMAssertionLevelOn), "StayAwake: Disabling screen sleep" as CFString, &assertionID) == kIOReturnSuccess {
                    stayAwake = true
                } else {
                    showErrorAlert = true
                }
            }
        }
        .alert("Error preventing screen sleep!", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        }
        Divider()
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }

    func buttonTitle() -> String {
        if stayAwake {
            return "Allow Sleep"
        } else {
            return "Prevent Sleep"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var assertionID: IOPMAssertionID = 0
    @State static var showErrorAlert: Bool = false

    static var previews: some View {
        ContentView(assertionID: $assertionID, showErrorAlert: $showErrorAlert)
    }
}
