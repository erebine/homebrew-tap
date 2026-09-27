# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.1/erebine-eim-agent-Darwin-arm64"
      version "2.3.1"
      sha256 "9ffddcbd36b70759d3fdcfcc1771b25ce829a4c434a83aa12960d66bf65d6b14"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.1/erebine-eim-agent-Linux-x86_64"
    version "2.3.1"
    sha256 "0a75800da7fb986f4c5459003d82fb82714fc70247f4fdc770cb090b02aa3eb3"
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
