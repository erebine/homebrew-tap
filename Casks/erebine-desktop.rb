# SPDX-License-Identifier: MIT
# Prebuilt Erebine Desktop app from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "2.3.2"
  sha256 "aee3c1c47c1aa6abce37381047f71914368f6eaf51046c8e0d48f78c05c2183b"

  url "https://github.com/Erebine/binaries/releases/download/v2.3.2/Erebine-Desktop-v2.3.2.dmg"
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
