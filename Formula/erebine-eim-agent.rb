# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.5.1/erebine-eim-agent-Darwin-arm64"
      version "2.5.1"
      sha256 "2078afa136de28e3086cc861a46613d4d1d62b236132c45fe1c90cdc6847ef43"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.5.0/erebine-eim-agent-Linux-x86_64"
    version "2.5.0"
    sha256 "b12aa2fdd51fde88756ec249f8b68206e522da8eca4780db81198b9043d1c656"
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
