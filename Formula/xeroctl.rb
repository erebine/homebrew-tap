# SPDX-License-Identifier: MIT
# Prebuilt xeroctl binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Xeroctl < Formula
  desc "Xerotier command-line client"
  homepage "https://xerotier.ai"
  version "0.0.0"
  license "MIT"

  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.0.0/xeroctl-Darwin-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.0.0/xeroctl-Linux-x86_64"
    sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  end

  def install
    bin.install Dir["xeroctl-*"].first => "xeroctl"
  end

  test do
    system bin/"xeroctl", "--help"
  end
end
