# SPDX-License-Identifier: MIT
# Prebuilt xeroctl binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Xeroctl < Formula
  desc "Xerotier command-line client"
  homepage "https://xerotier.ai"
  version "0.0.3"
  license "MIT"

  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.0.3/xeroctl-Darwin-arm64"
      sha256 "977721367ba557dd2e67116df2e8ef2e5fc90b00465a584ca004ec193b1733d8"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.0.3/xeroctl-Linux-x86_64"
    sha256 "e14256f59af3015b3cda06954c3f73542e62c56779df11c335fb2634daeefd32"
  end

  def install
    bin.install Dir["xeroctl-*"].first => "xeroctl"
  end

  test do
    system bin/"xeroctl", "--help"
  end
end
