# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  version "0.3.13-1-gf93ede61a-2-gdb5d4a3ab"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v0.3.13-1-gf93ede61a-2-gdb5d4a3ab/erebine-eim-agent-Darwin-arm64"
      sha256 "883caa332fd159c25b8bd0d8efd8813816c278d08166972b1f421ed7083af46a"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v0.3.13-1-gf93ede61a-2-gdb5d4a3ab/erebine-eim-agent-Linux-x86_64"
    sha256 "5c649276bdbf268fc8201cee0d26ff6845fcfa1b34af8942bcc928732c7ce400"
  end

  def install
    bin.install Dir["erebine-eim-agent-*"].first => "erebine-eim-agent"
  end

  test do
    system bin/"erebine-eim-agent", "--help"
  end
end
