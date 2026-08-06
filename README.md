# NexSign — iOS IPA Signer (UI)

This update transforms the template into a simple IPA signer app UI modeled visually after apps like Ksign or Feather. It intentionally does not perform any signing on-device. Instead, it's an attractive, modern UI that lists IPA files and provides a placeholder Sign action for future integration with zsign or remote signing services.

What's included
- Updated SwiftUI UI (Sources/NexSign/ContentView.swift) with a clean header, gradient background, list of IPAs, and prominent action buttons.
- The Sign button is disabled until an IPA is selected; pressing Sign currently performs a placeholder action.

How to run
1) Generate the Xcode project and open it (requires XcodeGen):
   xcodegen
   open NexSign.xcodeproj

2) In Xcode, pick a team and device to run; the app uses document picker to add IPA files from Files.

Next steps you might want
- Hook the Sign button to a signing flow (e.g., upload to a signing server or call a local script via a companion macOS app/extension).
- Add animations, previews for IPA icons, or metadata extraction from the IPA bundle.
- Add a GitHub Actions workflow to run zsign on macOS runners for CI signing.

