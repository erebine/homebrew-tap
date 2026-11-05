# SPDX-License-Identifier: MIT
# Prebuilt Erebine app (Erebine.app) from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "2.11.1"
  sha256 "93f23bc141f983e8627f89e8c2f208c19c04fd7b59d5467494719979b290dcb1"

  url "https://github.com/Erebine/binaries/releases/download/v#{version}/Erebine-Desktop-v#{version}.dmg"
  name "Erebine"
  desc "Desktop app for the Erebine platform"
  homepage "https://erebine.ai/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Erebine.app"

  zap trash: [
    "~/.config/erebine",
    "~/.local/lib/erebine",
    "~/Library/Preferences/com.erebine.agent.plist",
  ]
end
