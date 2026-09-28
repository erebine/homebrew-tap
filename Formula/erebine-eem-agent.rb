# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.4/erebine-eem-agent-Darwin-arm64"
      version "2.3.4"
      sha256 "b433a05657087cd7284b8e69c10851e141dfdc570b7730a45deec08587604599"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.4/erebine-eem-agent-Linux-x86_64"
    version "2.3.4"
    sha256 "07aaf542ec88d299c49ba13927d763690de00bc3c1ef7eb0881b4c0e6a2da5cc"
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
