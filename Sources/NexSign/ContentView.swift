import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var showingPicker = false
    @State private var ipaFiles: [URL] = []
    @State private var selectedIndex: Int? = nil

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient similar to Feather/Ksign subtle style
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9607843161, green: 0.9607843161, blue: 0.9882352948, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    header

                    if ipaFiles.isEmpty {
                        emptyState
                    } else {
                        ipaList
                    }

                    Spacer()

                    HStack(spacing: 12) {
                        Button(action: { showingPicker = true }) {
                            Label("Add IPA", systemImage: "plus.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PrimaryButtonStyle())

                        Button(action: signSelected) {
                            Label("Sign", systemImage: "checkmark.seal")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(selectedIndex == nil)
                        .opacity(selectedIndex == nil ? 0.6 : 1.0)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .navigationTitle("")
                .navigationBarHidden(true)
            }
        }
        .sheet(isPresented: $showingPicker) {
            DocumentPickerView(allowedContentTypes: [UTType(filenameExtension: "ipa")!]) { url in
                showingPicker = false
                guard let url = url else { return }
                // copy to app container if needed — for now keep URL reference
                ipaFiles.append(url)
                selectedIndex = ipaFiles.count - 1
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2039215714, green: 0.631372571, blue: 0.8549019694, alpha: 1)), Color(#colorLiteral(red: 0.5960784554, green: 0.1882352978, blue: 0.6901960969, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 64, height: 64)
                Image(systemName: "feather")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading) {
                Text("NexSign")
                    .font(.title2).bold()
                Text("Simple IPA signer — UI only (signing off-device)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "archivebox")
                .font(.system(size: 44))
                .foregroundColor(.secondary)
            Text("No IPAs added")
                .font(.headline)
            Text("Add an .ipa file to prepare it for signing. Signing is currently handled outside the app using zsign or other tools.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Button(action: { showingPicker = true }) {
                Text("Add IPA")
                    .frame(minWidth: 140)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 8)
        }
        .padding()
    }

    private var ipaList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(ipaFiles.indices, id: \ .self) { idx in
                    let url = ipaFiles[idx]
                    IPAListRow(url: url, isSelected: idx == selectedIndex)
                        .onTapGesture { selectedIndex = idx }
                        .padding(.horizontal)
                }
            }
            .padding(.top, 8)
        }
    }

    private func signSelected() {
        guard let idx = selectedIndex else { return }
        let url = ipaFiles[idx]
        // Placeholder action — signing not implemented in-app.
        print("Sign requested for: \(url.path)")
        // Show an alert or sheet in a future change — for now a simple print.
    }
}

struct IPAListRow: View {
    let url: URL
    var isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 56, height: 56)
                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                Image(systemName: "app.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(#colorLiteral(red: 0.2039215714, green: 0.631372571, blue: 0.8549019694, alpha: 1)))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(url.lastPathComponent)
                    .font(.subheadline)
                    .lineLimit(1)
                Text(fileSubtitle(url: url))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.blue.opacity(0.6) : Color.clear, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }

    func fileSubtitle(url: URL) -> String {
        let fm = FileManager.default
        if let attr = try? fm.attributesOfItem(atPath: url.path), let size = attr[.size] as? NSNumber {
            let formatter = ByteCountFormatter()
            formatter.countStyle = .file
            return formatter.string(fromByteCount: size.int64Value)
        }
        return "IPA"
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2039215714, green: 0.631372571, blue: 0.8549019694, alpha: 1)), Color(#colorLiteral(red: 0.5960784554, green: 0.1882352978, blue: 0.6901960969, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

// DocumentPickerView from previous template
struct DocumentPickerView: UIViewControllerRepresentable {
    var allowedContentTypes: [UTType]
    var onPick: (URL?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let vc = UIDocumentPickerViewController(forOpeningContentTypes: allowedContentTypes, asCopy: true)
        vc.delegate = context.coordinator
        vc.allowsMultipleSelection = true
        return vc
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL?) -> Void
        init(onPick: @escaping (URL?) -> Void) { self.onPick = onPick }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            // return first for compatibility with single-pick flows; parent handles appending
            onPick(urls.first)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onPick(nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
