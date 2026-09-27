# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.2/erebine-eim-agent-Darwin-arm64"
      version "2.3.2"
      sha256 "da50c5ebc364f8330f38ff22010f64f5c9638eabff256b93043b4cf49199a703"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.3/erebine-eim-agent-Linux-x86_64"
    version "2.3.3"
    sha256 "ab3ead61e953608c40e7943b4f2d1c528d71ffc22236d2fbc545134644fc403a"
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
