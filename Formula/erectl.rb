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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.8/erectl-Darwin-arm64"
      sha256 "ef5565d1e61dcbdd1a8cfeb718d09b36d3dfd2a407b1f54a379ed00f53e9a496"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.8/erectl-Darwin-arm64"
      sha256 "ef5565d1e61dcbdd1a8cfeb718d09b36d3dfd2a407b1f54a379ed00f53e9a496"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.8/erectl-Linux-x86_64"
      sha256 "b8567094802eebb60f5473731b5ab8d6dca04b8a25d4257be556a594c33c69d2"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.8/erectl-Linux-aarch64"
      sha256 "bdc386e2a7cfadac4d74eb1ec2407b35ed8465f222f10be008b8ae3d8c19c832"
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
