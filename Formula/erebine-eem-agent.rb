# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.2/erebine-eem-agent-Darwin-arm64"
      version "2.3.2"
      sha256 "f26d701f1cd48a4e49dc46f9f9e28dda8b11baf0e8ab191108311e020aa96d2c"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.3/erebine-eem-agent-Linux-x86_64"
    version "2.3.3"
    sha256 "8ecd6529873885099d0a9b74e54106f514cd282cdeee0911d087de005faa8716"
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
