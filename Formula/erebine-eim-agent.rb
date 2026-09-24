# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.2.1/erebine-eim-agent-Darwin-arm64"
      version "2.2.1"
      sha256 "6f8436e2e7813269e3b48347cf9841eb8634491bc1a2e23df502f0d215c547f6"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.2.1/erebine-eim-agent-Linux-x86_64"
    version "2.2.1"
    sha256 "91d32640c07716f6524236dde7da7eb92f1289bb5c1276ce4405d216e2bf96e2"
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
