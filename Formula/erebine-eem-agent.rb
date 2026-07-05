# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  version "0.3.13-1-gf93ede61a-2-gdb5d4a3ab"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v0.3.13-1-gf93ede61a-2-gdb5d4a3ab/erebine-eem-agent-Darwin-arm64"
      sha256 "61f3bb9c767601c7dd801682eec704375e2d89ed8175f892f10c64778d406a77"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v0.3.13-1-gf93ede61a-2-gdb5d4a3ab/erebine-eem-agent-Linux-x86_64"
    sha256 "332a1274e290866ada1eea18c400eb46186d06db38e1c8ab6f1563c3fb969a1e"
  end

  def install
    bin.install Dir["erebine-eem-agent-*"].first => "erebine-eem-agent"
  end

  test do
    system bin/"erebine-eem-agent", "--help"
  end
end
