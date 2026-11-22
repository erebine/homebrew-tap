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
      url "https://github.com/Erebine/binaries/releases/download/v3.6.0/erebine-eim-Darwin-arm64"
      sha256 "67a413391a604df6c812352aab2963a05b35fec617594fd01160f8d55aa8fb54"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.0/erebine-eim-Darwin-arm64"
      sha256 "67a413391a604df6c812352aab2963a05b35fec617594fd01160f8d55aa8fb54"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.0/erebine-eim-Linux-x86_64"
      sha256 "3371c29a680aea54c2680a75f57a1a508f1846e2727a763b32227ca83f0e6540"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.0/erebine-eim-Linux-aarch64"
      sha256 "c9acf430511c4d0d965fe7985d1a5534bd581cdb197122991255a0279e4f0b4d"
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
