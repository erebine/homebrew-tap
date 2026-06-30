# SPDX-License-Identifier: MIT
# Prebuilt Xerotier Desktop app from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "xerotier-desktop" do
  version "0.3.9"
  sha256 "0ed5c08b674cbe69ed37d7ee62c583290e1d20fdfcd77a191c1e863e4aaafd22"

  url "https://github.com/Xerotier/binaries/releases/download/v0.3.9/Xerotier-Desktop-v0.3.9.dmg"
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
