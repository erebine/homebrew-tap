# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.9.1/erebine-eem-agent-Darwin-arm64"
      version "2.9.1"
      sha256 "66ce69b1d68afc4ed2ff10c67372d5414c2218e78f39a26f59641791f833c487"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.9.1/erebine-eem-agent-Linux-x86_64"
    version "2.9.1"
    sha256 "ab8c3c4b7dc142657c4373ba6d15eaed473a46d4ff0fd62e539e57a29e0c2617"
  end

  depends_on "zeromq"
  depends_on "zstd"

  def install
    bin.install Dir["erebine-eem-agent-*"].first => "erebine-eem-agent"
  end

  test do
    system bin/"erebine-eem-agent", "--help"
  end
end
