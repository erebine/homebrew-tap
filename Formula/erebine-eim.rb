# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim binary, the Erebine Inference Microservice (EIM), from
# Erebine/binaries releases. Renamed from erebine-eim-agent in 2.10; see
# formula_renames.json.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEim < Formula
  desc "Erebine Inference Microservice (EIM)"
  homepage "https://erebine.ai"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.9.1/erebine-eim-agent-Darwin-arm64"
      version "2.9.1"
      sha256 "6f6419cf27c3a292b8cf4e6211b326afb588b57434130844ac1d3418cbf80602"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.9.1/erebine-eim-agent-Linux-x86_64"
      version "2.9.1"
      sha256 "065c3aee06d15ab2ac96d94d42966f262ff557b707ec04a9dc56d1331fe640a4"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.0/erebine-eim-Linux-aarch64"
      version "2.10.0"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    bin.install Dir["erebine-eim-*"].first => "erebine-eim"
    # The pre-2.10 name, for the units and scripts that still call it.
    bin.install_symlink "erebine-eim" => "erebine-eim-agent"
  end

  test do
    system bin/"erebine-eim", "--help"
    assert_path_exists bin/"erebine-eim-agent"
  end
end
