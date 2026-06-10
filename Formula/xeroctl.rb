# SPDX-License-Identifier: MIT
# Prebuilt xeroctl binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Xeroctl < Formula
  desc "Xerotier command-line client"
  homepage "https://xerotier.ai"
  version "0.0.1"
  license "MIT"

  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.0.1/xeroctl-Darwin-arm64"
      sha256 "64d53805de9542789d4d1fff24fa0a6a1ef24f26b258a71abc4be34f87f80257"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.0.1/xeroctl-Linux-x86_64"
    sha256 "7bdbabd59b4460fbf5cf2396a407e652a51170df21568223ad6b29505cc1efc8"
  end

  def install
    bin.install Dir["xeroctl-*"].first => "xeroctl"
  end

  test do
    system bin/"xeroctl", "--help"
  end
end
