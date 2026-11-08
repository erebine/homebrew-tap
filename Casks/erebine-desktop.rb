# SPDX-License-Identifier: MIT
# Prebuilt Erebine app (Erebine.app) from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "3.1.2"
  sha256 "c8336c89e9bd2f5d68af6a0751572264d734c6d0d87c0ba09813df6c2d21e9ed"

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
