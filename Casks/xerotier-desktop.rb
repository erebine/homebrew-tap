# SPDX-License-Identifier: MIT
# Prebuilt Xerotier Desktop app from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "xerotier-desktop" do
  version "0.0.1"
  sha256 "8fa00239ecee9a1549ffce8af702ad12e6d78561c09d7453bfe7157a8b1c3e43"

  url "https://github.com/Xerotier/binaries/releases/download/v0.0.1/Xerotier-Desktop-v0.0.1.dmg"
  name "Xerotier Desktop"
  desc "Desktop app for the Xerotier platform"
  homepage "https://xerotier.ai"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :sequoia"

  app "Xerotier.app"

  zap trash: [
    "~/.config/xerotier",
    "~/.local/lib/xerotier",
    "~/Library/Preferences/com.xerotier.agent.plist",
  ]
end
