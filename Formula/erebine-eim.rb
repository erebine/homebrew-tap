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
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.0/erebine-eim-Darwin-arm64"
      sha256 "9ff3a1ed5343dbeffcc7cc70d7956c68781266bb35e438231ddf8890f65f1183"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.0/erebine-eim-Darwin-arm64"
      sha256 "9ff3a1ed5343dbeffcc7cc70d7956c68781266bb35e438231ddf8890f65f1183"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.0/erebine-eim-Linux-x86_64"
      sha256 "1654a4fd1ddc6a5be665e1bc3745669cb49b140c8ade67a99f10fb451a3cb1a5"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.0/erebine-eim-Linux-aarch64"
      sha256 "2edde65c0b024aa6b7d44a2c63d2cd377d154e76132feca452c0f1d727201cae"
    end
  end

  def install
    binary = Dir["erebine-eim-*"].first
    # The Linux build finds libzmq and libzstd by soname in the loader's
    # default path, where Homebrew's are not: add their opt directories to
    # its RUNPATH, after the $ORIGIN the build set.
    if OS.linux?
      rpath = %w[zeromq zstd].map { |dep| formula_opt_lib(dep) }.join(":")
      system "patchelf", "--add-rpath", rpath, binary
    end
    bin.install binary => "erebine-eim"
    # The pre-2.10 name, for the units and scripts that still call it.
    bin.install_symlink "erebine-eim" => "erebine-eim-agent"
  end

  test do
    system bin/"erebine-eim", "--help"
    assert_path_exists bin/"erebine-eim-agent"
  end
end
