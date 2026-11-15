# SPDX-License-Identifier: MIT
# Prebuilt Erebine app (Erebine.app) from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
cask "erebine-desktop" do
  version "3.4.0"
  sha256 "6699c38d0bbda7c14b9d36d41844458f2440c1eef0346258c8f60520b65c3647"

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
