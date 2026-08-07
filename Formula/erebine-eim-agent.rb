# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  version "1.3.0"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v1.3.0/erebine-eim-agent-Darwin-arm64"
      sha256 "8b0fbdae2fe3069e2a696fc27d0e81f0b1d25d9eb0333b276f0f4b975d4f3865"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v1.3.0/erebine-eim-agent-Linux-x86_64"
    sha256 "40af7ca8b8018a54ba84f4e1a0a51f7b1414f1e17cc231a6103021e0b2be210e"
  end

  def install
    bin.install Dir["erebine-eim-agent-*"].first => "erebine-eim-agent"
  end

  test do
    system bin/"erebine-eim-agent", "--help"
  end
end
