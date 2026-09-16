# SPDX-License-Identifier: MIT
# Prebuilt Erebine Desktop app from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "2.0.2"
  sha256 "70083e95bbab182bb99e1d2c2e8d80fcd4c620f9c1141e2fe2d2c781abd5d698"

  url "https://github.com/Erebine/binaries/releases/download/v2.0.2/Erebine-Desktop-v2.0.2.dmg"
  name "Erebine Desktop"
  desc "Desktop app for the Erebine platform"
  homepage "https://erebine.ai"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :sequoia"

  app "Erebine.app"

  zap trash: [
    "~/.config/erebine",
    "~/.local/lib/erebine",
    "~/Library/Preferences/com.erebine.agent.plist",
  ]
end
