document.addEventListener("DOMContentLoaded", () => {
    const ipaInput = document.getElementById("ipa-input");
    const signBtn = document.getElementById("sign-btn");
    const statusBox = document.getElementById("status-box");
    const downloadBox = document.getElementById("download-box");

    async function triggerSigning(ipaFile) {
        statusBox.innerHTML = "Uploading IPA…";

        // Upload IPA to GitHub
        const uploadRes = await fetch(
            "https://api.github.com/repos/Kenonekeys/NexSign/actions/artifacts",
            {
                method: "POST",
                headers: {
                    "Authorization": `Bearer ${window.GITHUB_TOKEN}`,
                    "Content-Type": "application/octet-stream"
                },
                body: ipaFile
            }
        );

        if (!uploadRes.ok) {
            statusBox.innerHTML = "Upload failed.";
            return;
        }

        statusBox.innerHTML = "Triggering signing workflow…";

        // Trigger workflow
        const workflowRes = await fetch(
            "https://api.github.com/repos/Kenonekeys/NexSign/actions/workflows/deploy-ipa-signer-website.yml/dispatches",
            {
                method: "POST",
                headers: {
                    "Authorization": `Bearer ${window.GITHUB_TOKEN}`,
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    ref: "main",
                    inputs: {
                        ipa_path: "uploaded.ipa"
                    }
                })
            }
        );

        if (!workflowRes.ok) {
            statusBox.innerHTML = "Workflow trigger failed.";
            return;
        }

        statusBox.innerHTML = "Signing in progress…";

        pollForSignedIPA();
    }

    async function pollForSignedIPA() {
        const interval = setInterval(async () => {
            const res = await fetch(
                "https://kenonekeys.github.io/NexSign/assets/signed/signed.ipa"
            );

            if (res.ok) {
                clearInterval(interval);
                statusBox.innerHTML = "Signing complete!";
                downloadBox.style.display = "block";

                document.getElementById("signed-download").href =
                    "https://kenonekeys.github.io/NexSign/assets/signed/signed.ipa";

                document.getElementById("cert-zsign").href =
                    "https://kenonekeys.github.io/NexSign/assets/certpack/com.kenen.ikiowk.zsigncert";

                document.getElementById("cert-ksign").href =
                    "https://kenonekeys.github.io/NexSign/assets/certpack/com.kenen.ikiowk.ksign";

                document.getElementById("cert-kenprov").href =
                    "https://kenonekeys.github.io/NexSign/assets/certpack/com.kenen.ikiowk.kenprov";

                document.getElementById("cert-pfx").href =
                    "https://kenonekeys.github.io/NexSign/assets/certpack/ken1key.ken.pfx";

                document.getElementById("cert-esign").href =
                    "https://kenonekeys.github.io/NexSign/assets/certpack/com.kenen.ikiowk.esigncert";
            }
        }, 5000);
    }

    signBtn.addEventListener("click", () => {
        const file = ipaInput.files[0];
        if (!file) {
            statusBox.innerHTML = "Please select an IPA first.";
            return;
        }
        triggerSigning(file);
    });
});
