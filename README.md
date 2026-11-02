# Corneta Chocolatey package

The package downloads the official x64 NSIS installer and verifies SHA-256. It requires WebView2 Runtime, preserves the vendor's per-user installation behavior, and refuses to alter a running Corneta process.

Build with `choco pack corneta.nuspec`. Test installation, upgrade, and removal in a clean Windows VM before submitting. Do not use a workstation with real Corneta accounts, settings, or recordings for those tests.

The update workflow checks the latest stable GitHub release every six hours. It verifies the release files, SHA-256 checksums and installer signature, updates the package and validates it before submitting. Downgrades and changed bytes for an existing version are rejected. Store the account publishing key as the repository Actions secret `CHOCOLATEY_API_KEY`; never commit it. Acceptance remains subject to Chocolatey moderation.

The validation workflow checks installation, same-version reinstallation, uninstallation, binary layout, and preservation of synthetic application data on a disposable Windows runner. It never starts Corneta or publishes the generated package. A same-version reinstall does not cover an upgrade from an older release.

Chocolatey rejects new versions while the first submission has no approved version. The workflow reads the approval status of the initial 0.13.1 submission before publishing. While it is submitted for review, publication is skipped with an explicit waiting notice; the six-hour schedule resumes publication automatically after approval. An unexpected or rejected status fails for maintainer attention. A successful waiting run does not mean the latest version is available in Chocolatey.

For a manual check, run **Update Corneta** in Actions with `publish=false` (the default). Use `publish=true` from `main` for an actual submission. Pull requests validate without publishing or committing. The public package feed is checked before each submission, including versions awaiting moderation, so retries do not resubmit existing versions. If an upload fails after the metadata commit, a subsequent run retries the missing upload. The verifier is pinned to a reviewed commit of [Corneta](https://github.com/pitroldev/corneta).
