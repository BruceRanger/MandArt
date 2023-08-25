import SwiftUI
import AppKit


@available(macOS 11.0, *)
struct WelcomeMainInformationView: View {

  @EnvironmentObject var appState: AppState
  let showWelcomeScreen: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {

      Text("MandArt is the ultimate app for creating custom art from the Mandelbrot set.")
        .font(.title3)
        .foregroundColor(.primary)

      Text("Find an interesting location (e.g., where two black areas meet), zoom in and out, and customize the coloring. Nearby colors flow into one another, so check their gradients to see how the intermediate colors appear. If you'll print your art, choose from colors more likely to print true.")
        .foregroundColor(.secondary)

      Button(action: {
        NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: nil, from: nil)
        NSDocumentController.shared.newDocument("new.mandart")
      }) {
        Text("Click here to open default MandArt document and get started")
          .fontWeight(.semibold)
      }
      .buttonStyle(.bordered)
      .controlSize(.large)

      Toggle(isOn: $appState.showWelcomeScreen) {
        Text("Show welcome screen when starting")
      }
      .onTapGesture {
        // do nothing else
      }
      .onChange(of: appState.showWelcomeScreen) { newValue in
        UserDefaults.standard.setValue(newValue, forKey: "shouldShowWelcome")
      }

    }
  }
}
