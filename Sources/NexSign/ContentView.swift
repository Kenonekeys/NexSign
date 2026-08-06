import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var showingPicker = false
    @State private var selectedURL: URL?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("NexSign iOS Template")
                    .font(.title)
                    .padding(.top)

                Text("This template lets the user pick an IPA file from Files. Signing is handled outside the app using zsign. See README for instructions.")
                    .multilineTextAlignment(.center)
                    .padding()

                if let url = selectedURL {
                    Text("Selected: \(url.lastPathComponent)")
                        .font(.subheadline)
                        .lineLimit(2)
                        .padding()
                }

                Button(action: { showingPicker = true }) {
                    Text("Pick an IPA")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("NexSign")
            .sheet(isPresented: $showingPicker) {
                DocumentPickerView(allowedContentTypes: [UTType(filenameExtension: "ipa")!]) { url in
                    selectedURL = url
                }
            }
        }
    }
}

struct DocumentPickerView: UIViewControllerRepresentable {
    var allowedContentTypes: [UTType]
    var onPick: (URL?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let vc = UIDocumentPickerViewController(forOpeningContentTypes: allowedContentTypes, asCopy: true)
        vc.delegate = context.coordinator
        vc.allowsMultipleSelection = false
        return vc
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL?) -> Void
        init(onPick: @escaping (URL?) -> Void) { self.onPick = onPick }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onPick(urls.first)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onPick(nil)
        }
    }
}
