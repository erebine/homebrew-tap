# SPDX-License-Identifier: MIT
# Prebuilt xerotier-xim-agent binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class XerotierXimAgent < Formula
  desc "Xerotier XIM inference agent"
  homepage "https://xerotier.ai"
  version "0.3.9"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.3.9/xerotier-xim-agent-Darwin-arm64"
      sha256 "a646374ccf613db2641e0210451a15364a65547d69080568aa3e36a4b35afd79"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.3.9/xerotier-xim-agent-Linux-x86_64"
    sha256 "5c649276bdbf268fc8201cee0d26ff6845fcfa1b34af8942bcc928732c7ce400"
  end

  def install
    bin.install Dir["xerotier-xim-agent-*"].first => "xerotier-xim-agent"
  end

  test do
    system bin/"xerotier-xim-agent", "--help"
  end
end
