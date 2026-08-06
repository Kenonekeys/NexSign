# NexSign iOS app template

This repository contains a minimal iOS app template (SwiftUI) plus helper files to integrate zsign for IPA signing.

What this provides
- XcodeGen project definition (project.yml) so you can generate an Xcode project locally.
- Minimal SwiftUI app source in Sources/NexSign (Document picker to choose an IPA file).
- A shell script to sign an IPA using zsign (scripts/sign_with_zsign.sh).
- README with setup and usage instructions.

Notes
- iOS apps cannot run codesigning tools on-device. This template does not perform signing on-device — it includes a helper zsign script to run on macOS where zsign is available.
- To generate the Xcode project install XcodeGen and run `xcodegen` in the repo root.

Files added:
- project.yml (XcodeGen project)
- Info.plist
- Sources/NexSign/App.swift
- Sources/NexSign/ContentView.swift
- scripts/sign_with_zsign.sh
- README.md
- .gitignore
- LICENSE (MIT)

