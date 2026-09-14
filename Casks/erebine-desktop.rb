# SPDX-License-Identifier: MIT
# Prebuilt Erebine Desktop app from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "1.10.1"
  sha256 "c43f26ba9189f3ab62f6e55537020e6164905d19d5c60eb7062624766662c111"

  url "https://github.com/Erebine/binaries/releases/download/v1.10.1/Erebine-Desktop-v1.10.1.dmg"
  name "Erebine Desktop"
  desc "Desktop app for the Erebine platform"
  homepage "https://erebine.ai"

  livecheck do
    skip "No DMG has shipped since v1.10.1"
  end

  # v1.10.1 is the last release carrying a DMG; every release since is Linux
  # x86_64 only. The pinned DMG still downloads, so the cask is deprecated
  # rather than disabled: existing users keep a working install path and get
  # told it is going nowhere.
  deprecate! date: "2026-09-14", because: :discontinued

  depends_on arch: :arm64
  depends_on macos: ">= :sequoia"

  app "Erebine.app"

  zap trash: [
    "~/.config/erebine",
    "~/.local/lib/erebine",
    "~/Library/Preferences/com.erebine.agent.plist",
  ]
end
