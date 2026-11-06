# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.0.0/erectl-Darwin-arm64"
      sha256 "46a496c5e68d112e5ba525375f065b847317ec375bd82ffb5beb2c9dd0f6be98"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.0.0/erectl-Darwin-arm64"
      sha256 "46a496c5e68d112e5ba525375f065b847317ec375bd82ffb5beb2c9dd0f6be98"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.0.0/erectl-Linux-x86_64"
      sha256 "7fc6f63df2ab3be9ea507fcf3f55a76c8432eecbf06cff5f54191f9f993cf953"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.0.0/erectl-Linux-aarch64"
      sha256 "d20ca8eb5d78562ae50dcd49e932bc7f2a15c1aedbde982815c70a76e0abfddf"
    end
  end

  def install
    binary = Dir["erectl-*"].first
    # The Linux build finds libzstd and libcurl by soname in the loader's
    # default path, where Homebrew's are not: add their opt directories to
    # its RUNPATH, after the $ORIGIN the build set.
    if OS.linux?
      rpath = %w[zstd curl].map { |dep| formula_opt_lib(dep) }.join(":")
      system "patchelf", "--add-rpath", rpath, binary
    end
    bin.install binary => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
