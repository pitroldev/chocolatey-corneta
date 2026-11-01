# Corneta Chocolatey package

The package downloads the official x64 NSIS installer and verifies SHA-256. It requires WebView2 Runtime, preserves the vendor's per-user installation behavior, and refuses to alter a running Corneta process.

Build with `choco pack corneta.nuspec`. Test installation, upgrade, and removal in a clean Windows VM before submitting. Do not use a workstation with real Corneta accounts, settings, or recordings for those tests.

Upload the resulting `corneta.0.13.1.nupkg` through an authenticated Chocolatey Community account, or use `choco push` with an already configured account key. Never commit credentials. Acceptance is subject to Chocolatey moderation.

The GitHub Actions workflow validates installation, same-version reinstallation, uninstallation, binary layout, and preservation of synthetic application data on a disposable Windows runner. It never starts Corneta or publishes the generated package. Check its latest result before submitting; a same-version reinstall does not cover an upgrade from an older release.
