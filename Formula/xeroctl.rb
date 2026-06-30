# SPDX-License-Identifier: MIT
# Prebuilt xeroctl binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Xeroctl < Formula
  desc "Xerotier command-line client"
  homepage "https://xerotier.ai"
  version "0.3.9"
  license "MIT"

  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.3.9/xeroctl-Darwin-arm64"
      sha256 "a19b0c4fbcd5093ac91f00ac75a90a4895241411722989a2da7cc06e95038a8c"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.3.9/xeroctl-Linux-x86_64"
    sha256 "8de6b8259d084b53bbc3c9df2cb1adc126a865abff20489bc473f91af141bf4c"
  end

  def install
    bin.install Dir["xeroctl-*"].first => "xeroctl"
  end

  test do
    system bin/"xeroctl", "--help"
  end
end
