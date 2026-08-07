# SPDX-License-Identifier: MIT
# Prebuilt Erebine Desktop app from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "1.3.0"
  sha256 "0f2ce1069c37d6375aec1431e87da25172bcdba73fefdec2d55997a5992030d5"

  url "https://github.com/Erebine/binaries/releases/download/v1.3.0/Erebine-Desktop-v1.3.0.dmg"
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
