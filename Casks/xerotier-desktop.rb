# SPDX-License-Identifier: MIT
# Prebuilt Xerotier Desktop app from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "xerotier-desktop" do
  version "0.0.3"
  sha256 "b402d35aea04192b7983b5db190d0e1105bcdcbc08acaacfef7e299dcbb3e6be"

  url "https://github.com/Xerotier/binaries/releases/download/v0.0.3/Xerotier-Desktop-v0.0.3.dmg"
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
