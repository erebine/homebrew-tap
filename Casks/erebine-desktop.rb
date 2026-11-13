# SPDX-License-Identifier: MIT
# Prebuilt Erebine app (Erebine.app) from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "3.3.9"
  sha256 "63625273cf657d9c34a7874397598b52b5c6b76a79bae5f70f222155c7756c0f"

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
