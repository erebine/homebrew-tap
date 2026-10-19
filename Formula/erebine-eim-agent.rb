# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.6.0/erebine-eim-agent-Darwin-arm64"
      version "2.6.0"
      sha256 "44a2edaf9edd9ded2cb3de5999d7513b6ce666417974720e288dbbb889be49bf"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.6.0/erebine-eim-agent-Linux-x86_64"
    version "2.6.0"
    sha256 "f1bcff913fb9137291e40799fefe58045438ab4adb91b747c78928b7f0362b66"
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
