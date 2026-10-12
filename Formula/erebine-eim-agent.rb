# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.5.2/erebine-eim-agent-Darwin-arm64"
      version "2.5.2"
      sha256 "ccc82cb38c39becab2190aa2e54ebd3db414303e49ca18dded7af60bd6c44b48"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.5.2/erebine-eim-agent-Linux-x86_64"
    version "2.5.2"
    sha256 "ae19312c0f980d44e20f5c8cf19edac99432d962082f80f4243827b143548df6"
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
