Xcode template

This branch contains a minimal Xcode template skeleton to get started.

Included files:
- Template.xcodeproj/ (placeholder project)
- Sources/ExampleApp/ (basic AppDelegate and ViewController)
- Info.plist (minimal)
- .gitignore

Notes on .ipa handling
- Committing .ipa files directly into the repository is discouraged because binaries bloat the git history.
- Recommended: build the .ipa locally, upload it to a GitHub Release or external storage (Dropbox, S3), and add the download link here.
- If you want the .ipa stored in the repo, enable Git LFS for large files or provide a direct URL and I can fetch and add it.

How to use
1. Open Xcode and create/replace a real project using the Template.xcodeproj placeholder.
2. Implement app-specific targets/resources.

