# SPDX-License-Identifier: MIT
# Prebuilt Erebine app (Erebine.app) from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "2.10.0"
  sha256 "9d6b02569c067e9d073b9d8a8993390b78a8c0e830a2f58286e6d7f22494508e"

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
