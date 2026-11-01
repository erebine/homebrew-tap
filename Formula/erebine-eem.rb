# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem binary, the Erebine Execution Manager (EEM), from
# Erebine/binaries releases. Renamed from erebine-eem-agent in 2.10; see
# formula_renames.json.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEem < Formula
  desc "Erebine Execution Manager (EEM)"
  homepage "https://erebine.ai"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.9.1/erebine-eem-agent-Darwin-arm64"
      version "2.9.1"
      sha256 "66ce69b1d68afc4ed2ff10c67372d5414c2218e78f39a26f59641791f833c487"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.9.1/erebine-eem-agent-Linux-x86_64"
      version "2.9.1"
      sha256 "ab8c3c4b7dc142657c4373ba6d15eaed473a46d4ff0fd62e539e57a29e0c2617"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.0/erebine-eem-Linux-aarch64"
      version "2.10.0"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    bin.install Dir["erebine-eem-*"].first => "erebine-eem"
    # The pre-2.10 name, for the units and scripts that still call it.
    bin.install_symlink "erebine-eem" => "erebine-eem-agent"
  end

  test do
    system bin/"erebine-eem", "--help"
    assert_path_exists bin/"erebine-eem-agent"
  end
end
