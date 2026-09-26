# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.0/erebine-eim-agent-Darwin-arm64"
      version "2.3.0"
      sha256 "7a41ae924ad6765f690f26786b44eccf6f5379a3b01a3ba054cc4fce66be3a7f"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.0/erebine-eim-agent-Linux-x86_64"
    version "2.3.0"
    sha256 "21c65d0ab0fa615124676d9577b32635675d2f4557260517965ceac7cbb62e50"
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
