# SPDX-License-Identifier: MIT
# Prebuilt Erebine Desktop app from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "0.3.13-1-gf93ede61a-2-gdb5d4a3ab"
  sha256 "1062cb8e173fdb002f12010a69687024ee51a8454ffd350fe4246b98f2915597"

  url "https://github.com/Erebine/binaries/releases/download/v0.3.13-1-gf93ede61a-2-gdb5d4a3ab/Erebine-Desktop-v0.3.13-1-gf93ede61a-2-gdb5d4a3ab.dmg"
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
