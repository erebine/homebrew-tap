# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.4/erebine-eim-agent-Darwin-arm64"
      version "2.3.4"
      sha256 "75e91e4b7d5f259c0ad4a0e0dc5e57cb29eb3b48debcd8e530c3c700d16df59d"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.4/erebine-eim-agent-Linux-x86_64"
    version "2.3.4"
    sha256 "4c9ad8e47fecb80ea72fbd6c1f00e1b19d7d8d4e0db696743974172e165816e7"
  end

  depends_on "zeromq"
  depends_on "zstd"

  def install
    bin.install Dir["erebine-eim-agent-*"].first => "erebine-eim-agent"
  end

  test do
    system bin/"erebine-eim-agent", "--help"
  end
end
