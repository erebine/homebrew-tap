# SPDX-License-Identifier: MIT
# Prebuilt Xerotier Desktop app from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "xerotier-desktop" do
  version "0.1.0"
  sha256 "b221f3a0aace93a48bd98fe9a5e9795f8abb541997f2a88bbf8180404acdf0be"

  url "https://github.com/Xerotier/binaries/releases/download/v0.1.0/Xerotier-Desktop-v0.1.0.dmg"
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
