# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.9.1/erebine-eim-agent-Darwin-arm64"
      version "2.9.1"
      sha256 "6f6419cf27c3a292b8cf4e6211b326afb588b57434130844ac1d3418cbf80602"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.9.1/erebine-eim-agent-Linux-x86_64"
    version "2.9.1"
    sha256 "065c3aee06d15ab2ac96d94d42966f262ff557b707ec04a9dc56d1331fe640a4"
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
