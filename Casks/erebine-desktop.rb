# SPDX-License-Identifier: MIT
# Prebuilt Erebine Desktop app from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "2.5.2"
  sha256 "66f8b372578110678e6ca6137298b9ba536480396ddc03af6dd43c0596cc6633"

  url "https://github.com/Erebine/binaries/releases/download/v2.5.2/Erebine-Desktop-v2.5.2.dmg"
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
