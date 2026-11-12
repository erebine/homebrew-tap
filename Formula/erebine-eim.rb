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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.8/erebine-eim-Darwin-arm64"
      sha256 "ba2889bae3dc38aafcbe2f9d7c46122fa0baafe514e92d53f3cc4572f44b497b"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.8/erebine-eim-Darwin-arm64"
      sha256 "ba2889bae3dc38aafcbe2f9d7c46122fa0baafe514e92d53f3cc4572f44b497b"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.8/erebine-eim-Linux-x86_64"
      sha256 "22caa2d1e7ec1d77055cef9f57e8fd90e5ee5f0e7bccec0ac32e4bc85af684a6"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.8/erebine-eim-Linux-aarch64"
      sha256 "9cc6f7dab7c0b492c5b69d13849743cea2f5d354a622114f0ecf1a64c100d6c8"
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
