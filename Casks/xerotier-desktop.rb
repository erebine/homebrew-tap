# SPDX-License-Identifier: MIT
# Prebuilt Xerotier Desktop app from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "xerotier-desktop" do
  version "0.0.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://github.com/Xerotier/binaries/releases/download/v0.0.0/Xerotier-Desktop-0.0.0.dmg"
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
