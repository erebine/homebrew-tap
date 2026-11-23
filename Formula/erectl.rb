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
      url "https://github.com/Erebine/binaries/releases/download/v3.6.2/erectl-Darwin-arm64"
      sha256 "2ee3c45b94aab65a1999cfe77db21f9b4e08fc61ee1856ed6e5341476c11d592"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.2/erectl-Darwin-arm64"
      sha256 "2ee3c45b94aab65a1999cfe77db21f9b4e08fc61ee1856ed6e5341476c11d592"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.2/erectl-Linux-x86_64"
      sha256 "b3b7997015cea26f0aa9cc852859074c18ca20cb7faf30ecb6f621c42fa017e9"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.2/erectl-Linux-aarch64"
      sha256 "dba34d8a3348f1f4beebb68d3d909184aa1cdf5c29a2812cd58b4ba671f71eeb"
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
