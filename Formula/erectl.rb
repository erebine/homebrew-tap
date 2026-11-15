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
      url "https://github.com/Erebine/binaries/releases/download/v3.4.0/erectl-Darwin-arm64"
      sha256 "ce590dd3c9d33e53b2d072c3809cb9d1924301b14c31b9bec3a3fd88731c0113"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.4.0/erectl-Darwin-arm64"
      sha256 "ce590dd3c9d33e53b2d072c3809cb9d1924301b14c31b9bec3a3fd88731c0113"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.4.0/erectl-Linux-x86_64"
      sha256 "bd7a46db3d40ed3ee9b914c5c060202af9022ed0665c9019099ea2928671a6b5"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.4.0/erectl-Linux-aarch64"
      sha256 "a256929b1603d3885f16da9affd2f1a5821d7c12e082448aeb117af4e3898b72"
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
